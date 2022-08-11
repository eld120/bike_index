class OrganizationStolenMessage < ApplicationRecord
  MAX_BODY_LENGTH = 400
  KIND_ENUM = {area: 0, association: 1}
  MAX_SEARCH_RADIUS = 1000

  include SearchRadiusMetricable

  belongs_to :organization

  has_many :stolen_records

  validates :organization_id, presence: true, uniqueness: true

  before_validation :set_calculated_attributes

  delegate :search_coordinates, :metric_units?, to: :organization, allow_nil: true

  enum kind: KIND_ENUM

  scope :enabled, -> { where(is_enabled: true) }
  scope :disabled, -> { where(is_enabled: false) }

  geocoded_by nil, latitude: :latitude, longitude: :longitude

  def self.kinds
    KIND_ENUM.keys.map(&:to_s)
  end

  def self.max_search_radius_kilometers
    miles_to_kilometers(MAX_SEARCH_RADIUS)
  end

  def self.for_stolen_record(stolen_record)
    return stolen_record.organization_stolen_message if stolen_record.organization_stolen_message.present?
    area_result = for_coordinates(stolen_record.to_coordinates)
    return area_result if area_result.present?
    stolen_record.bike.bike_organizations.includes(:organization).order(:id)
      .detect { |bo| bo.organization.organization_stolen_message&.is_enabled? }
      &.organization&.organization_stolen_message
  end

  def self.for_coordinates(coordinates)
    searched_radius = 0
    enabled.area.near(coordinates, MAX_SEARCH_RADIUS).detect do |org_stolen_message|
      # Ignore stolen_messages with have a search radius smaller than nearer ones
      next if searched_radius > org_stolen_message.search_radius_miles
      searched_radius = org_stolen_message.search_radius_miles
      org_stolen_message.distance_to(coordinates) < org_stolen_message.search_radius_miles
    end
  end

  def self.clean_body(str)
    return nil if str.blank?
    ActionController::Base.helpers.strip_tags(str).gsub("&amp;", "&")
      .strip.gsub(/\s+/, " ").truncate(MAX_BODY_LENGTH, omission: "")
  end

  def self.default_kind_for_organization_kind(org_kind)
    %w[law_enforcement bike_advocacy].include?(org_kind) ? "area" : "association"
  end

  # never geocode, use organization lat/long
  def should_be_geocoded?
    false
  end

  def editable_subject?
    false # match mail_snippet method
  end

  def max_body_length
    MAX_BODY_LENGTH
  end

  def disabled?
    !is_enabled?
  end

  def set_calculated_attributes
    self.body = self.class.clean_body(body)
    self.latitude = organization&.location_latitude
    self.longitude = organization&.location_longitude
    self.kind ||= self.class.default_kind_for_organization_kind(organization&.kind)
    self.content_added_at ||= Time.current if body.present?
    self.is_enabled = false unless can_enable?
    self.search_radius_miles = MAX_SEARCH_RADIUS if search_radius_miles > MAX_SEARCH_RADIUS
    self.report_url = Urlifyer.urlify(report_url)
  end

  private

  def can_enable?
    return false if body.blank?
    return true if association?
    latitude.present? && longitude.present? && search_radius_miles.present?
  end
end
