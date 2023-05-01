# frozen_string_literal: true

RSpec.describe Dsu::Support::FolderLocations do
  describe 'sanity checks' do
    describe 'Dir.home' do
      it 'returns the correct mocked folder' do
        expect(Dir.home).to eq Dir.tmpdir
      end
    end
  end

  describe 'class methods' do
    describe '.root_folder' do
      it 'returns the users home folder' do
        expect(described_class.root_folder).to eq Dir.home
      end
    end

    describe '.temp_folder' do
      it 'returns the temp folder' do
        expect(described_class.temp_folder).to eq Dir.tmpdir
      end
    end
  end
end
