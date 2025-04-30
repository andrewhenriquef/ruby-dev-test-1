require 'rails_helper'

RSpec.describe Directory, type: :model do
  describe 'associations' do
    it do
      is_expected.to belong_to(:parent_directory)
        .class_name('Directory')
        .with_foreign_key(:parent_id)
        .optional
    end

    it do
      is_expected.to have_many(:subdirectories)
        .class_name('Directory')
        .with_foreign_key(:parent_id)
        .dependent(:destroy)
        .inverse_of(:parent_directory)
    end

    it do
      is_expected.to have_many(:documents)
        .dependent(:destroy)
        .inverse_of(:directory)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#path' do
    context 'when the directory has no parent directory' do
      subject { build(:directory, name: 'test') }

      it 'returns the path of the directory' do
        expect(subject.path).to eq('test')
      end
    end

    context 'when the directory has a parent directory' do
      subject do
        build(
          :directory,
          name: 'test',
          parent_directory: build(:directory, name: 'parent')
        )
      end

      it 'returns the path of the directory with the parent directory' do
        expect(subject.path).to eq('parent/test')
      end
    end
  end

  describe '#is_root?' do
    context 'when the directory has no parent directory' do
      subject { build(:directory, name: 'test') }

      it 'returns true if the directory is a root directory' do
        expect(subject.is_root?).to be_truthy
      end
    end

    context 'when the directory has a parent directory' do
      subject do
        build(
          :directory,
          name: 'test',
          parent_directory: build(:directory, name: 'parent')
        )
      end

      it 'returns false if the directory is not a root directory' do
        expect(subject.is_root?).to be_falsey
      end
    end
  end

  describe '#is_subdirectory?' do
    context 'when the directory has a parent directory' do
      subject do
        build(
          :directory,
          name: 'test',
          parent_directory: build(:directory, name: 'parent')
        )
      end

      it 'returns true if the directory is a subdirectory' do
        expect(subject.is_subdirectory?).to be_truthy
      end
    end

    context 'when the directory has no parent directory' do
      subject { build(:directory, name: 'test') }

      it 'returns false if the directory is not a subdirectory' do
        expect(subject.is_subdirectory?).to be_falsey
      end
    end
  end
end
