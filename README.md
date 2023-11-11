# SwissMunicipality

## Getting started

Install the gem or add it to your Gemfile.

```sh
gem install swiss_municipality
```

```ruby
# Gemfile
gem 'swiss_municipality'
```

## Usage

Get canton

```ruby
SwissMunicipality.canton(zip_code: '8001', language: 'de', variant: :full)
# => 'Zürich'

# German, french and italian is supported
SwissMunicipality.canton(zip_code: '8001', language: 'it')
# => 'Zurigo'

SwissMunicipality.canton(zip_code: '8001', variant: :short)
# => 'ZH'

SwissMunicipality.canton(municipality: 'Gockhausen', variant: :short)
# => 'ZH'

SwissMunicipality.all_cantons(variant: :short)
# => ['BE', ZH', ...]
```

Get municipality

```ruby
SwissMunicipality.municipality(zip_code: '7748')
# => 'Campascio'

SwissMunicipality.all_municipalities(canton: 'ZH')
# => ['Gockhausen', 'Oberengstringen']

SwissMunicipality.all_municipalities
# => ['Alp Grüm', Gockhausen', 'Oberengstringen', ...]
```

Get zip code

```ruby
SwissMunicipality.all_zip_codes
# => ['3000', '8000', '8001', ...]

SwissMunicipality.all_zip_codes(canton: 'ZH')
# => ['8000', '8001', ...]

SwissMunicipality.all_zip_codes(canton: 'ZH', variant: :with_municipality)
# => ['8000 Zürich', '8001 Zürich', ...]

SwissMunicipality.all_zip_codes(municipality: 'Zürich')
# => ['8000', '8001', ...]
```