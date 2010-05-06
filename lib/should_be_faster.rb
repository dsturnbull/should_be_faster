require 'benchmark'
require 'spec'
require 'spec/matchers'
require 'spec/matchers/be'

def _benchmark(code, iter)
  Benchmark.measure { iter.times { code.call } }
end

module Spec
  module Matchers
    class BenchmarkComparison
      def initialize(rhs_code, options={})
        @rhs_code = rhs_code
        @options  = options
        @options[:iterations] ||= 100
        @options[:factor]     ||= 1
        @options[:faster]       = @options[:faster]
      end

      def benchmark_comparison
        factor  = @options[:factor]
        iter    = @options[:iterations]
        matcher = @options[:matcher]
        faster  = @options[:faster]
        rhs     = _benchmark(@rhs_code, iter).real
        lhs     = nil

        matcher.match do |lhs_code|
          lhs = (_benchmark(lhs_code, iter).real * factor)
          if faster
            lhs < rhs
          else
            lhs > rhs
          end
        end

        matcher.instance_eval do
          failure_message_for_should do |actual|
            if faster
              "ran too slow: #{lhs / rhs}x, #{lhs - rhs}s"
            else
              "ran too fast: #{rhs / lhs}x, #{rhs - lhs}s"
            end
          end

          failure_message_for_should_not do |actual|
            if faster
              "ran too slow: #{rhs / lhs}x, #{rhs - lhs}s"
            else
              "ran too fast: #{lhs / rhs}x, #{lhs - rhs}s"
            end
          end

          description do
            if faster
              "be faster than #{rhs}"
            else
              "be slower than #{rhs}"
            end
          end
        end
      end
    end

    module BeFasterThan
      def times
        @factor = @args[0]
        self
      end

      def faster_than(rhs_code, options={})
        options ||= {}
        options[:factor] = @factor
        Matcher.new(:faster_than) do
          options[:faster]  = true
          options[:matcher] = self
          Spec::Matchers::BenchmarkComparison.new(rhs_code, options).benchmark_comparison
        end
      end

      def slower_than(rhs_code, options={})
        options ||= {}
        options[:factor] = @factor
        Matcher.new(:slower_than) do
          options[:faster]  = false
          options[:matcher] = self
          Spec::Matchers::BenchmarkComparison.new(rhs_code, options).benchmark_comparison
        end
      end
    end

  end
end

Spec::Matchers::BePredicate.send(:include, Spec::Matchers::BeFasterThan)
Spec::Matchers::BeSameAs.send(:include, Spec::Matchers::BeFasterThan)

Spec::Matchers.define(:be_faster_than) do |rhs_code, options|
  options ||= {}
  options[:matcher] = self
  options[:faster]  = true
  Spec::Matchers::BenchmarkComparison.new(rhs_code, options).benchmark_comparison
end

Spec::Matchers.define(:be_slower_than) do |rhs_code, options|
  options ||= {}
  options[:matcher] = self
  options[:faster]  = false
  Spec::Matchers::BenchmarkComparison.new(rhs_code, options).benchmark_comparison
end

