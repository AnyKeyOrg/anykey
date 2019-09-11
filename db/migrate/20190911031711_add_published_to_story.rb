class AddPublishedToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :published, :boolean, default: false
    add_column :stories, :published_on, :datetime, precision: 0
  end
end
