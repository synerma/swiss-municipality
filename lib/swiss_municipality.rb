# gem build swiss_municipality.gemspec
# gem install ./swiss_municipality-0.1.1.gem

# require 'swiss_municipality'
#


class SwissMunicipality
  def self.canton(**options)
    options = sanitize_options(options)
    validate_identifier(options)
    validate_variant(options)
    
    raise ArgumentError, 'Argument canton must not be given' unless options[:canton].nil?

    if options[:municipality].nil?
      zip_code_data = MunicipalityData.zip_hash[options[:zip_code]]

      raise ArgumentError, "No municipality found for zip code #{options[:zip_code]}" if zip_code_data.nil?
      
      canton_data = zip_code_data[:canton]
    else
      municipality_data = MunicipalityData.municipality_hash[options[:municipality]]
      canton_data = municipality_data[:canton]
    end

    if options[:variant] == :short
      canton_data[:short]
    elsif options[:variant] == :full
      canton_data[options[:language]]
    end
  end

  def self.all_cantons(options)
    options = sanitize_options(options)
    validate_variant(options)

    if options[:variant] == :short
      MunicipalityData.canton_hash.keys.sort
    elsif options[:variant] == :full
      MunicipalityData.canton_hash.values.map { |canton| canton[:full_name][options[:language]] }
    end
  end

  def self.municipality(**options)
    options = sanitize_options(options)
    validate_identifier(options)

    raise ArgumentError, 'Argument municipality must not be given' unless options[:municipality].nil?
    raise ArgumentError, 'Argument canton must not be given' unless options[:canton].nil?

    zip_code_data = MunicipalityData.zip_hash[options[:zip_code]]
    zip_code_data[:municipality]
  end

  def self.all_municipalities(**options)
    options = sanitize_options(options)

    if options[:canton].nil?
      MunicipalityData.municipality_hash
    else
      MunicipalityData.canton_hash[options[:canton]][:municipalities]
    end.keys.sort.map(&:to_s)
  end

  def self.all_zip_codes(**options)
    options = sanitize_options(options)

    if !options[:municipality].nil?
      zip_code_data = MunicipalityData.municipality_hash[options[:municipality]][:zip_codes]
    elsif !options[:canton].nil?
      zip_code_data = MunicipalityData.canton_hash[options[:canton]][:zip_codes]
    else
      zip_code_data = MunicipalityData.zip_hash.keys
    end

    if options[:variant] == :with_municipality
      zip_code_data.map { |zip_code| [zip_code, MunicipalityData.zip_hash[zip_code.to_sym][:municipality]].join(' ') }
    else
      zip_code_data.map(&:to_s)
    end.sort
  end

  private
  
  def self.sanitize_options(options)
    options[:variant] = options[:variant]&.to_s&.downcase&.to_sym
    options[:language] = options[:language]&.to_s&.downcase&.gsub('-ch', '')&.to_s&.to_sym
    options[:zip_code] = options[:zip_code]&.to_s&.to_sym
    options[:municipality] = options[:municipality]&.to_s&.to_sym
    options[:canton] = options[:canton]&.to_s&.to_sym

    options
  end

  def self.validate_variant(options)
    unless %i[short full].include? options[:variant]
      raise ArgumentError, "'Argument variant must be provided. The allowed values are 'short' and 'full'"
    end

    if options[:variant] == :full && !(%i[de fr it].include?(options[:language]))
      raise ArgumentError, "Language must be provided for variant :full. The allowed values are 'de-CH', 'de', 'fr-CH', 'fr', 'it-CH', 'it'"
    end
  end
  
  def self.validate_identifier(options)
    if [options[:zip_code], options[:municipality], options[:canton]].compact.count != 1
      raise ArgumentError, 'Exactly one of the arguments zip_code, municipality or canton must be given'
    end
  end
end

require 'swiss_municipality/municipality_data'
