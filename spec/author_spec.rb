require('spec_helper')

@@create_author = lambda do |attributes|
  base = {:last_name => "", :first_name => "", :id => nil}
  base.merge!(attributes)
  Author.new(base)
end

describe('#save') do
  it('adds an author to the list of authors') do
    test_author = @@create_author.call({:last_name => "King"})
    test_author.save()
    expect(Author.all()).to(eq([test_author]))
  end
end

describe('#delete') do
  it('deletes the author') do
    test_author1 = @@create_author.call({:last_name => "King"})
    test_author1.save()
    test_author2 = @@create_author.call({:last_name => "Andreski"})
    test_author2.save()
    test_author1.delete()
    expect(Author.all()).to(eq([test_author2]))
  end
end

describe('#update') do
  it('updates the last name') do
    test_author = @@create_author.call({:last_name => "King"})
    test_author.save()
    test_author.update({:last_name => "Andreski"})
    expect(test_author.last_name()).to(eq("Andreski"))
  end
  
  it('updates the first name') do
    test_author = @@create_author.call({:first_name => "Stephen"})
    test_author.save()
    test_author.update({:first_name => "Stanislav"})
    expect(test_author.first_name()).to(eq("Stanislav"))
  end
  
  it('update first and last names') do
    test_author = @@create_author.call({:first_name => "Stephen"})
    test_author.save()
    test_author.update({:last_name => "Andreski", :first_name => "Stanislav"})
    expect(test_author.first_name()).to(eq("Stanislav"))
    expect(test_author.last_name()).to(eq("Andreski"))
  end
end

describe('.all') do
  it('starts as an empty array') do
    expect(Author.all()).to(eq([]))
  end
end

describe('#==') do
  it('compares authors based on their names') do
    test_author1 = @@create_author.call({:last_name => "Andreski", :first_name => "Stanislav"})
    test_author1.save()
    test_author2 = @@create_author.call({:last_name => "Andreski", :first_name => "Stanislav"})
    test_author2.save()
    expect(test_author1 == test_author2).to(eq(true))
  end
end