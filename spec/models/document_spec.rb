require 'rails_helper'

RSpec.describe Document, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:file) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:directory) }
  end

  describe "attachments" do
    it { is_expected.to have_one_attached(:file) }
  end

  describe "instance methods" do
    let(:file_name) { "test.txt" }
    let(:file_path) do
      Rails.root.join(
        "spec",
        "fixtures",
        "files",
        file_name
      )
    end
    let(:content_type) { "text/plain" }
    let(:file) { fixture_file_upload(file_path, content_type) }
    let(:directory) { build(:directory, name: "root") }
    let(:document) { build(:document, file: file, directory: directory) }
    let(:document_name) { document.name }

    subject { document }

    describe "#name" do
      it "returns the name of the file" do
        expect(subject.name).to eq(document_name)
      end
    end

    describe "#path" do
      it "returns the path of the file" do
        expect(subject.path).to eq("root/test.txt")
      end
    end

    describe '#file' do
      let(:document) { create(:document) }

      it 'has a file attached' do
        expect(document.file).to be_attached
      end

      it 'can read file content' do
        expect(document.file.download).to eq 'dummy file'
      end
    end

    describe "#original_filename" do
      it "returns the original filename" do
        expect(subject.original_filename).to eq(file_name)
      end
    end
  end
end
