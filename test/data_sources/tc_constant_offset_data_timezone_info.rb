# frozen_string_literal: true

require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'test_utils')

include TZInfo

module DataSources
  class TCConstantOffsetDataTimezoneInfo < Minitest::Test
    def test_initialize
      o = TimezoneOffset.new(-17900, 0, :TESTLMT)
      i = ConstantOffsetDataTimezoneInfo.new('Test/Zone', o)

      assert_equal('Test/Zone', i.identifier)
      assert_same(o, i.constant_offset)
    end

    def test_initialize_nil_identifier
      o = TimezoneOffset.new(-17900, 0, :TESTLMT)

      error = assert_raises(ArgumentError) { ConstantOffsetDataTimezoneInfo.new(nil, o) }
      assert_match(/\bidentifier\b/, error.message)
    end

    def test_initialize_nil_constant_offset
      error = assert_raises(ArgumentError) { ConstantOffsetDataTimezoneInfo.new('Test/Zone', nil) }
      assert_match(/\bconstant_offset\b/, error.message)
    end

    def test_period_for
      o = TimezoneOffset.new(-17900, 0, :TESTLMT)
      i = ConstantOffsetDataTimezoneInfo.new('Test/Zone', o)

      assert_equal(OffsetTimezonePeriod.new(o), i.period_for(Timestamp.for(Time.utc(2017,1,1,0,0,0))))
      assert_equal(OffsetTimezonePeriod.new(o), i.period_for(Timestamp.for(Time.new(2017,1,1,0,0,0,0))))
      assert_equal(OffsetTimezonePeriod.new(o), i.period_for(Timestamp.for(Time.new(2017,1,1,1,0,0,3600))))
    end

    def test_periods_for_local
      o = TimezoneOffset.new(-17900, 0, :TESTLMT)
      i = ConstantOffsetDataTimezoneInfo.new('Test/Zone', o)

      assert_equal([OffsetTimezonePeriod.new(o)], i.periods_for_local(Timestamp.for(Time.utc(2017,1,1,0,0,0), :ignore)))
    end

    def test_transitions_up_to
      i = ConstantOffsetDataTimezoneInfo.new('Test/Zone', TimezoneOffset.new(-17900, 0, :TESTLMT))

      assert_equal([], i.transitions_up_to(Timestamp.for(Time.utc(2017,1,1,0,0,0))))
    end

    def test_inspect
      i = ConstantOffsetDataTimezoneInfo.new('Test/Zone', TimezoneOffset.new(0, 0, :TEST))
      assert_equal('#<TZInfo::DataSources::ConstantOffsetDataTimezoneInfo: Test/Zone>', i.inspect)
    end
  end
end
