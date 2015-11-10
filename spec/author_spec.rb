require('spec_helper')

describe('#save') do
  it('adds an author') do
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
    expect(Author.find(test_author.id()).last_name()).to(eq("Andreski"))
  end
  
  it('updates the first name') do
    test_author = @@create_author.call({:first_name => "Stephen"})
    test_author.save()
    test_author.update({:first_name => "Stanislav"})
    expect(Author.find(test_author.id()).first_name()).to(eq("Stanislav"))
  end
  
  it('update first and last names') do
    test_author = @@create_author.call({:first_name => "Stephen"})
    test_author.save()
    test_author.update({:last_name => "Andreski", :first_name => "Stanislav"})
    expect(Author.find(test_author.id()).last_name()).to(eq("Andreski"))
    expect(Author.find(test_author.id()).first_name()).to(eq("Stanislav"))
  end
end

describe('.all') do
  it('starts as an empty array') do
    expect(Author.all()).to(eq([]))
  end
end

describe('.find') do
  it('finds an author based on their id') do
    test_author1 = @@create_author.call({:last_name => "King"})
    test_author1.save()
    test_author2 = @@create_author.call({:last_name => "Andreski"})
    test_author2.save()
    expect(Author.find(test_author1.id())).to(eq(test_author1))
  end
end

describe('.search_by') do
  it('finds authors based on a single criterion') do
    test_author1 = @@create_author.call({:last_name => "Smith", :first_name => "John"})
    test_author2 = @@create_author.call({:last_name => "Doe", :first_name => "Jane"})
    test_author1.save()
    test_author2.save()
    expect(Author.search_by({:last_name => "Smith"})).to(eq([test_author1]))
  end
  
  it('returns multiple matching authors') do
    test_author1 = @@create_author.call({:last_name => "Smith", :first_name => "John"})
    test_author2 = @@create_author.call({:last_name => "Smith", :first_name => "Jon"})
    test_author1.save()
    test_author2.save()
    expect(Author.search_by({:last_name => "Smith"})).to(eq([test_author1, test_author2]))
  end
  
  it('finds authors based on multiple criteria') do
    test_author1 = @@create_author.call({:last_name => "Smith", :first_name => "John"})
    test_author2 = @@create_author.call({:last_name => "Smith", :first_name => "Jon"})
    test_author1.save()
    test_author2.save()
    expect(Author.search_by({:last_name => "Smith", :first_name => "John"})).to(eq([test_author1]))
  end
  
  it('returns false if a single criterion does not match') do
    test_author1 = @@create_author.call({:last_name => "Smith", :first_name => "John"})
    test_author2 = @@create_author.call({:last_name => "Smith", :first_name => "Jon"})
    test_author1.save()
    test_author2.save()
    expect(Author.search_by({:last_name => "Smith", :first_name => "Jawn"})).to(eq(false))
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