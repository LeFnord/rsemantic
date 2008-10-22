require File.dirname(__FILE__) + '/../spec_helper'

module Semantic
  describe Frequency do

    it "should caculate term frequency" do
      Frequency::term_frequency(10,5).should == 2
    end

    it "should caculate inverse document frequency" do
      x = Frequency::inverse_document_frequency(10,5)
      x.should be_close(0.693, 0.001)
    end

  end
end
