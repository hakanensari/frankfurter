# frozen_string_literal: true

require_relative "helper"
require "day"

describe Day do
  describe ".latest" do
    it "returns latest available rates on given date" do
      date = Date.parse("2010-01-04")
      data = Day.latest(date)
      _(data.to_a.sample.date).must_equal(date)

      date = Date.parse("2010-01-01")
      data = Day.latest(date)
      _(data.to_a.sample.date).must_equal(Date.parse("2009-12-31"))
    end

    it "returns nothing if date predates dataset" do
      _(Day.latest(Date.parse("1901-01-01"))).must_be_empty
    end
  end

  describe ".between" do
    it "returns rates between given working dates" do
      start_date = Date.parse("2010-01-04")
      end_date = Date.parse("2010-01-29")
      dates = Day.between((start_date..end_date)).map(:date).sort
      _(dates.first).must_equal(start_date)
      _(dates.last).must_equal(end_date)
    end

    it "starts on preceding business day if start date is a holiday" do
      start_date = Date.parse("2024-11-03")
      end_date = Date.parse("2024-11-04")
      dates = Day.between((start_date..end_date)).map(:date)
      _(dates).must_include(Date.parse("2024-11-01"))
    end

    it "returns nothing if end date predates dataset" do
      interval = (Date.parse("1901-01-01")..Date.parse("1901-01-31"))
      _(Day.between(interval)).must_be_empty
    end

    it "allows start date to predate dataset" do
      start_date = Date.parse("1901-01-01")
      end_date = Date.parse("2024-01-01")
      dates = Day.between((start_date..end_date)).map(:date)
      _(dates).wont_be_empty
    end

    it "returns nothing if queried for the future" do
      start_date = Date.today + 1
      end_date = start_date + 1
      dates = Day.between((start_date..end_date)).map(:date)
      _(dates).must_be_empty
    end
  end
end
