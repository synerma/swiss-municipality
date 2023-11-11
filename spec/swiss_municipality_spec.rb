# frozen_string_literal: true

require 'spec_helper'
require 'swiss_municipality'

describe SwissMunicipality do
  describe 'when calling the .canton method' do
    it 'returns the canton for a given zip code' do
      expect(SwissMunicipality.canton(zip_code: 8008, variant: :short)).to eq('ZH')
    end

    it 'returns a full variant of the canton in a given language' do
      expect(SwissMunicipality.canton(zip_code: 8008, variant: :full, language: :it)).to eq('Zurigo')
    end

    it 'returns the canton for a given municipality' do
      expect(SwissMunicipality.canton(municipality: 'Gockhausen', variant: :short)).to eq('ZH')
    end

    it 'returns an error when both zip code and municipality are given' do
      expect do
        SwissMunicipality.canton(municipality: 'Gockhausen', zip_code: 8008, variant: :short)
      end.to raise_error(ArgumentError)
    end

    it 'returns an error when neither the zip code, nor the municipality is given' do
      expect { SwissMunicipality.canton(variant: :short) }.to raise_error(ArgumentError)
    end

    it 'automatically casts arguments to the correct type' do
      expect(SwissMunicipality.canton(zip_code: '8008', variant: 'full', language: 'it-ch')).to eq('Zurigo')
    end
  end

  describe 'when calling the .all_cantons method' do
    it 'returns all cantons in a short variant' do
      expect(SwissMunicipality.all_cantons(variant: :short)).to eq(%i[AG AI AR BE BL BS FR GE GL GR JU LU NE NW OW SG
                                                                      SH SO SZ TG TI UR VD VS ZG ZH])
    end

    it 'returns all cantons in a full variant in the desired language' do
      expect(SwissMunicipality.all_cantons(variant: :full, language: :fr).count).to eq(26)
      expect(SwissMunicipality.all_cantons(variant: :full, language: :fr).include?('Bâle-Campagne')).to eq(true)
      expect(SwissMunicipality.all_cantons(variant: :full, language: :fr).include?('Nidwald')).to eq(true)
    end
  end

  describe 'when calling the .municipality method' do
    it 'returns the municipality for a given zip code' do
      expect(SwissMunicipality.municipality(zip_code: 1442)).to eq('Montagny-près-Yverdon')
    end
  end

  describe 'when calling the .all_municipalities method' do
    it 'returns all municipalities' do
      expect(SwissMunicipality.all_municipalities.count).to eq(3993)
      expect(SwissMunicipality.all_municipalities.include?('Aathal-Seegräben')).to eq(true)
      expect(SwissMunicipality.all_municipalities.include?('Zwillikon')).to eq(true)
    end

    it 'returns all municipalities of a given canton' do
      expect(SwissMunicipality.all_municipalities(canton: 'SO').count).to eq(139)
      expect(SwissMunicipality.all_municipalities(canton: 'SO').include?('Grenchen')).to eq(true)
      expect(SwissMunicipality.all_municipalities(canton: 'SO').include?('Selzach')).to eq(true)
    end
  end

  describe 'when calling the .all_zip_codes method' do
    it 'returns all zip codes' do
      expect(SwissMunicipality.all_zip_codes.count).to eq(3203)
      expect(SwissMunicipality.all_zip_codes.include?('8008')).to eq(true)
      expect(SwissMunicipality.all_zip_codes.include?('3027')).to eq(true)
    end

    it 'returns all zip codes of a given municipality' do
      expect(SwissMunicipality.all_zip_codes(municipality: 'Bern').count).to eq(16)
      expect(SwissMunicipality.all_zip_codes(municipality: 'Bern').include?('3006')).to eq(true)
      expect(SwissMunicipality.all_zip_codes(municipality: 'Bern').include?('3027')).to eq(true)
    end

    it 'returns all zip codes of a given canton' do
      expect(SwissMunicipality.all_zip_codes(canton: 'BL').count).to eq(87)
      expect(SwissMunicipality.all_zip_codes(canton: 'BL').include?('4102')).to eq(true)
      expect(SwissMunicipality.all_zip_codes(canton: 'BL').include?('4144')).to eq(true)
    end

    it 'returns all zip codes of a given canton including their municipality name' do
      expect(SwissMunicipality.all_zip_codes(canton: 'BL', variant: :with_municipality).count).to eq(87)
      expect(SwissMunicipality.all_zip_codes(canton: 'BL',
                                             variant: :with_municipality).include?('2814 Roggenburg')).to eq(true)
      expect(SwissMunicipality.all_zip_codes(canton: 'BL',
                                             variant: :with_municipality).include?('4104 Oberwil BL')).to eq(true)
    end
  end
end
