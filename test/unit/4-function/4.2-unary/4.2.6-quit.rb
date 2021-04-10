describe '4.2.6 QUIT' do
	include Kn::Test::Spec

	def exit_code(expr)
		# exit codes shouldn't print anything.
		assert_silent do
			exec "QUIT #{expr}", raise_on_failure: false
		end

		$?.exitstatus
	end

	it 'must quit the process with the given return value' do
		assert_equal 0, exit_code(0)
		assert_equal 1, exit_code(1)
		assert_equal 2, exit_code(2)
		assert_equal 10, exit_code(10)
		assert_equal 49, exit_code(49)
		assert_equal 123, exit_code(123)
		assert_equal 126, exit_code(126)
		assert_equal 127, exit_code(127)
	end

	it 'must convert to an integer' do
		assert_equal 12, exit_code('"12"')

		# these are slightly counterintuitive, as `QUIT TRUE` will exit with 1, indicating failure.
		assert_equal 1, exit_code('TRUE')
		assert_equal 0, exit_code('FALSE')
		assert_equal 0, exit_code('NULL')
	end

	it 'requires exactly one argument', when_testing: :argument_count do
		assert_fails { eval('QUIT') }
		assert_runs  { eval('QUIT 0') }
	end

	it 'does not allow blocks as the first operand', when_testing: :strict_types do
		assert_fails { eval('; = a 0 : QUIT BLOCK a') }
		assert_fails { eval('QUIT BLOCK QUIT 0') }
	end
end
