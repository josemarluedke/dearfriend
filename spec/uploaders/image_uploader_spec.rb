require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  before do
    ImageUploader.enable_processing = true
    project = Project.new
    @uploader = ImageUploader.new(project, :image)
    @uploader.store!(File.open(File.join(Rails.root, "spec", "fixtures", "images", "image.jpg")))
  end

  after do
    ImageUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the resized image' do
    it "Should be a 1200x370 image" do
      @uploader.should have_dimensions(1200,370)
    end
  end

  context 'the thumb image' do
    it "Should be a 620x270 image" do
      @uploader.thumb.should have_dimensions(620, 270)
    end
  end
end
