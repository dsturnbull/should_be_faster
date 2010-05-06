require 'lib/should_be_faster'

describe 'should_be_faster' do
  it 'should default to 100 iterations' do
    options = mock('hash')
    options.stub!(:[]).and_return(nil)
    options.stub!(:[]=)
    options.should_receive(:[]=).with(:iterations, 100)
    Spec::Matchers::BenchmarkComparison.new(nil, options)
  end

  context 'with an options hash' do
    it 'should allow you to specify iterations' do
      options = mock('hash')
      options.stub!(:[])
      options.stub!(:[]=)
      options.stub!(:[]).with(:iterations).and_return(20)
      Spec::Matchers::BenchmarkComparison.new(nil, options)
      options[:iterations].should == 20
    end

    it 'should allow you to specify factor' do
      options = mock('hash')
      options.stub!(:[])
      options.stub!(:[]=)
      options.stub!(:[]).with(:factor).and_return(20)
      Spec::Matchers::BenchmarkComparison.new(nil, options)
      options[:factor].should == 20
    end
  end

  context 'when ensuring code is' do
    before do
      @fast = lambda { [1, 2, 3, 4, 5, 6, 7, 8, 9].sort }
      @slow = lambda { 100.times.map { rand } }
    end

    context 'faster_than' do
      it 'should ensure lhs  < rhs' do
        @fast.should be_faster_than(@slow)
      end

      it 'should ensure lhs  < rhs by x times' do
        @fast.should be_faster_than(@slow, :factor => 2)
      end

      it 'should ensure lhs !> rhs' do
        @slow.should_not be_faster_than(@fast)
      end

      it 'should ensure lhs !> rhs by x times' do
        @slow.should_not be_faster_than(@fast, :factor => 2)
      end
    end

    context 'slower_than' do
      it 'should ensure lhs  > rhs' do
        @slow.should be_slower_than(@fast)
      end

      it 'should ensure lhs  > rhs by x times' do
        @slow.should be_slower_than(@fast, :factor => 2)
      end

      it 'should ensure lhs !< rhs' do
        @fast.should_not be_slower_than(@slow)
      end

      it 'should ensure lhs !< rhs by x times' do
        @fast.should_not be_slower_than(@slow, :factor => 2)
      end
    end

    context 'at_least(x).times.faster_than' do
      it 'should ensure lhs  < rhs' do
        @fast.should be_at_least(2).times.faster_than(@slow)
      end

      it 'should ensure lhs !> rhs' do
        @slow.should_not be_at_least(2).times.faster_than(@fast)
      end
    end

    context 'at_least(x).times.slower_than' do
      it 'should ensure lhs  > rhs' do
        @slow.should be_at_least(2).times.slower_than(@fast)
      end

      it 'should ensure lhs !< rhs' do
        @fast.should_not be_at_least(2).times.slower_than(@slow)
      end
    end

    context 'x.times.slower_than' do
      it 'should ensure lhs  > rhs' do
        @slow.should be(2).times.slower_than(@fast)
      end

      it 'should ensure lhs !< rhs' do
        @fast.should_not be(2).times.slower_than(@slow)
      end
    end

    context 'x.times.faster_than' do
      it 'should ensure lhs  > rhs' do
        @fast.should be(2).times.faster_than(@slow)
      end

      it 'should ensure lhs !< rhs' do
        @slow.should_not be(2).times.faster_than(@fast)
      end
    end
  end
end
