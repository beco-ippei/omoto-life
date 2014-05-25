require 'spec_helper'

describe Photo do
  describe '#valid?' do
    context 'temp file' do
      subject { Photo.new file: file }
      let(:file) do
        #TODO ????
        file = 'file'
        def file.content_type
          @ctype
        end
        def file.content_type=(ctype)
          @ctype = ctype
        end
        file.content_type = file_content_type
        file
      end

      context 'exist' do
        context 'content_type is nil' do
          let(:file_content_type) { nil }
          its(:valid?) { should be false }
        end

        context 'content_type is "image/gif"' do
          let(:file_content_type) { 'image/gif' }
          its(:valid?) { should be false }
        end

        context 'content_type is "image/jpeg"' do
          let(:file_content_type) { 'image/jpeg' }
          its(:valid?) { should be true }
        end
      end

      context 'not exist' do
        let(:file) { nil }
        its(:valid?) { should be true }
      end
    end
  end
end
