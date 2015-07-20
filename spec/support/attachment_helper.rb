module AttachmentHelper
  def stub_attachment_behaviour
    # by stubbing out the has_attached_file class method call on the Project
    # model, this should stop Paperclip from being initialized during test runs,
    # therefore our tests should run faster
    #
    allow(Project).to receive(:has_attached_file).and_return(true)
  end

  def path_to_stub_uploaded_image(filename = 'image.jpg')
    "spec/fixtures/paperclip/#{filename}"
  end

  def stub_uploaded_image(filename = 'image.jpg', filetype = 'image/jpeg')
    Rack::Test::UploadedFile.new(path_to_stub_uploaded_image(filename), filetype)
  end
end

RSpec.configure do |config|
  config.include AttachmentHelper

  config.before(:each) do
    # stub_attachment_behaviour
  end
end
FactoryGirl::SyntaxRunner.send(:include, AttachmentHelper)
