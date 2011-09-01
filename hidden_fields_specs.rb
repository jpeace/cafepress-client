require './hidden_fields'

describe CafePress::HiddenFields do
    
  it "parses a single simple hidden input field" do
    html = %{<input type="hidden" name="test" value="test_data" />}
    cut = CafePress::HiddenFields.new(html)
    
    cut.tokens.size.should == 1
    cut.tokens['test'].should == 'test_data'
  end
  
  it "parses a single complex hidden input field" do
    html = %{<input attr0="value0" type="hidden" attr1="value1" name="test" attr2="value2" value="test_data" attr3="value3" />}
    cut = CafePress::HiddenFields.new(html)
    
    cut.tokens.size.should == 1
    cut.tokens['test'].should == 'test_data'
  end
  
  it "handles single quotes, too" do
    html = %{<input type='hidden' name='test' value='test_data' />}
    cut = CafePress::HiddenFields.new(html)
    
    cut.tokens.size.should == 1
    cut.tokens['test'].should == 'test_data'
  end
  
end