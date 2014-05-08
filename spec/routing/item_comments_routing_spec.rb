require "spec_helper"

describe CommentsController do
  describe "routing" do

    it "routes to #index" do
      get("/items/1/comments")
        .should route_to("comments#index", item_id: '1')
    end

    it "routes to #create" do
      post("/items/2/comments")
        .should route_to("comments#create", item_id: '2')
    end

    it "routes to #destroy" do
      delete("/items/3/comments/4")
        .should route_to("comments#destroy", item_id: '3', id: '4')
    end

    describe 'path helper' do
      let(:item) { Item.new(id: 1) }
      it { item_comments_path(item).should == '/items/1/comments' }
    end
  end
end

