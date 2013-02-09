require 'active_support/all'
require 'decent_decoration'

describe DecentDecoration::Decoration do
  let(:klass) { DecentDecoration::Decoration }

  it "should be initialized with name" do
    subject = klass.new(:conference)
    subject.name.should == :conference
  end

  it "should be initialized with options" do
    subject = klass.new(:conference, { model: :conference })
    subject.options.should == { model: :conference }
  end

  describe "#undecorated_name" do
    it "should consist of name prepended by undecorated" do
      klass.new(:conference).undecorated_name.should == :undecorated_conference
    end
  end

  describe "#decorator_class" do
    it "should infer the class from name" do
      klass.new(:conference).decorator_class.should == ConferenceDecorator
    end

    it "should use :decorator if passed" do
      klass.new(:conference, decorator: AttendeeDecorator).decorator_class.should == AttendeeDecorator
    end
  end

  describe "#decorate_method" do
    describe "when name is plural" do
      subject { klass.new(:conferences, decorator: decorator) }
      let(:decorator) { stub }

      it "should be :decorate_collection if decorator supports it" do
        decorator.stub(:decorate_collection)
        subject.decorate_method.should == :decorate_collection
      end

      it "should be :decorate if decorator does not support :decorate_collection and supports :decorate" do
        decorator.stub(:decorate)
        subject.decorate_method.should == :decorate
      end

      it "should be :new if decorator does not support :decorate_collection or :decorate" do
        subject.decorate_method.should == :new
      end
    end

    describe "when name is singular" do
      subject { klass.new(:conference, decorator: decorator) }
      let(:decorator) { stub }

      it "should not be :decorate_collection even if decorator supports it" do
        decorator.stub(:decorate_collection)
        subject.decorate_method.should_not == :decorate_collection
      end

      it "should be :decorate if decorator does not supports it" do
        decorator.stub(:decorate)
        subject.decorate_method.should == :decorate
      end

      it "should be :new if decorator does not support :decorate" do
        subject.decorate_method.should == :new
      end
    end
  end
end