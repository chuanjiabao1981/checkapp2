RSpec::Matchers.define :allow do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end

RSpec::Matchers.define :allow_param do |*args|
  match do |permission|
    permission.allow_param?(*args).should be_true
  end
end

RSpec::Matchers.define :allow_nested_param do |*args|
	match do |permission|
		permission.allow_nested_param?(*args).should be_true
	end
end

RSpec::Matchers.define :have_the_link do |*args|
	match do |page|
		s = nil
		page.all('a').each do |a|
			s= [:href] if args[0] == a[:href]
		end
		s.should_not be_nil
	end
end