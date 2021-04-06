class AddSmalImageUrlToAds < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :mobile_image_url, :string, default: '', null: false
  end
end
