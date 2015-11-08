require('spec_helper')

@@create_book = lambda do |attributes|
  base = {:title => '', :checkout => '1919-05-08', :author_id => 0, :patron_id => 0, :id => nil}
  base.merge!(attributes)
  Book.new(base)
end

describe('.search_by') do
  it('finds books matching a single criterion') do
    test_author1 = @@create_author.call({:last_name => "Conrad", :first_name => "Joseph"})
    test_author1.save()
    test_author2 = @@create_author.call({:last_name => "Rowling", :first_name => "Joanne"})
    test_author2.save()
    test_book1 = @@create_book.call({:title => "Social Sciences as Sorcery", :author_id => test_author1.id()})
    test_book1.save()
    test_book2 = @@create_book.call({:title => "Philosophical Investigations", :author_id => test_author2.id()})
    test_book2.save()
    expect(Book.search_by({:title => "Philosophical Investigations"})).to(eq(test_book2))
  end
  
  it('finds books matching multiple criteria') do
    test_author1 = @@create_author.call({:last_name => "Conrad", :first_name => "Joseph"})
    test_author1.save()
    test_author2 = @@create_author.call({:last_name => "Rowling", :first_name => "Joanne"})
    test_author2.save()
    test_book1 = @@create_book.call({:title => "Heart of Darkness", :author_id => test_author1.id()})
    test_book1.save()
    test_book2 = @@create_book.call({:title => "Heart of Darkness", :author_id => test_author2.id()})
    test_book2.save()
    expect(Book.search_by({:title => "Heart of Darkness", :last_name => "Conrad", :first_name => "Joseph"})).to(eq(test_book1))
  end
  
  it('returns false when a single criteria does not match') do
    test_author1 = @@create_author.call({:last_name => "Conrad", :first_name => "Joseph"})
    test_author1.save()
    test_author2 = @@create_author.call({:last_name => "Rowling", :first_name => "Joanne"})
    test_author2.save()
    test_book1 = @@create_book.call({:title => "Heart of Darkness", :author_id => test_author1.id()})
    test_book1.save()
    test_book2 = @@create_book.call({:title => "Heart of Darkness", :author_id => test_author2.id()})
    test_book2.save()
    expect(Book.search_by({:title => "Heart of Darkness", :last_name => "Rowling", :first_name => "Joseph"})).to(eq(false))
  end
end

describe('#overdue?') do
  it('returns true when a book is checked out for three weeks') do
    test_book = @@create_book.call({:checkout => (Date.new() - 21)})
    expect(test_book.overdue?()).to(eq(true))
  end
end

describe('#save') do
  it('saves a book') do
    test_book = @@create_book.call({})
    test_book.save()
    expect(Book.all()).to(eq([test_book]))
  end
end

describe('#delete') do
  it('deletes a book') do
    test_book = @@create_book.call({})
    test_book.save()
    test_book.delete()
    expect(Book.all()).to(eq([]))
  end
end

describe('#update') do
  it('updates a single attribute') do
    test_book = @@create_book.call({})
    test_book.save()
    test_book.update({:title => "Social Sciences as Sorcery"})
    expect(Book.find(test_book.id()).title()).to(eq("Social Sciences as Sorcery"))
  end
  
  it('updates multiple attributes') do
    test_book = @@create_book.call({})
    test_book.save()
    test_book.update({:title => "Social Sciences as Sorcery", :patron_id => 3, :checkout => Date.parse("1919-05-08")})
    expect(Book.find(test_book.id()).title()).to(eq("Social Sciences as Sorcery"))
    expect(Book.find(test_book.id()).patron_id()).to(eq(3))
    expect(Book.find(test_book.id()).checkout()).to(eq(Date.parse("1919-05-08")))
  end
end

describe('.all') do
  it('starts as an empty array') do
    expect(Book.all()).to(eq([]))
  end
end

describe('.find') do
  it('finds a book based on its id') do
    test_book1 = @@create_book.call({:title => "Philosophical Investigations"})
    test_book1.save()
    test_book2 = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book2.save()
    expect(Book.find(test_book1.id())).to(eq(test_book1))
  end
end

describe('#==') do
  it('compares books based on their title') do
    test_book1 = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book2 = @@create_book.call({:title => "Social Sciences as Sorcery"})
    expect(test_book1 == test_book2).to(eq(true))
  end
end