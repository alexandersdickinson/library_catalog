require('spec_helper')

@@create_book = lambda do |attributes|
  base = {:title => '', :checkout => '1919-05-08', :author_id => 0, :patron_id => 0, :id => nil}
  base.merge!(attributes)
  Book.new(base)
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
    test_book.update({:title => "Social Sciences as Sorcery", :patron_id => 3, :checkout => "1919-05-08"})
    expect(Book.find(test_book.id()).title()).to(eq("Social Sciences as Sorcery"))
    expect(Book.find(test_book.id()).patron_id()).to(eq(3))
    expect(Book.find(test_book.id()).checkout()).to(eq("1919-05-08"))
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