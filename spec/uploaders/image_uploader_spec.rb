require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  before do
    ImageUploader.enable_processing = true
    project = Project.new
    @uploader = ImageUploader.new(project, :image)
    @uploader.store!(File.open(File.join(Rails.root, "spec", "fixtures", "images", "image.png")))
  end

  after do
    ImageUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it "TODO: define thumb size" do
      @uploader.thumb.should have_dimensions(64, 64)
    end
  end
end