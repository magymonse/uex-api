require "rails_helper"
require Rails.root.join("lib/utility")

describe Utility do
  describe "#translate_boolean" do
    it "with true boolean return 'Si'" do
      expect(Utility.translate_boolean(true)).to eq("Si")
    end

    it "with false boolean return 'No'" do
      expect(Utility.translate_boolean(false)).to eq("No")
    end

    it "with nil return blank space" do
      expect(Utility.translate_boolean(nil)).to eq("")
    end

    it "with some string return blank space" do
      expect(Utility.translate_boolean("Hello")).to eq("")
    end

    it "with blank space return blank space" do
      expect(Utility.translate_boolean("")).to eq("")
    end
  end
end
