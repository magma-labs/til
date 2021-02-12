class AddAds < ActiveRecord::Migration[5.0]
  def change
    create_table :ads do |t|
      t.string :image_url, null: false
      t.string :link_url, null: false
      t.integer :clicks, null: false, default: 0

      t.timestamps
    end

    reversible do |change|
      change.up do
        Ad.create(image_url: "https://www.dropbox.com/s/9kevwegmvj53whd/973983_AdforCodeReview_v3_0211021_C02_021121.png?dl=1", link_url: "http://pages.magmalabs.io/on-demand-github-code-reviews-for-your-pull-requests")
      end
    end
  end
end
