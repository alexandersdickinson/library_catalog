require('spec_helper')

describe('#check_out') do
  it('assigns a book to a patron') do
    test_book = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book.save()
    test_patron = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron.save()
    test_patron.check_out(test_book)
    expect(test_book.patron_id()).to(eq(test_patron.id()))
  end
  
  it('sets the checkout date to the current date') do
    test_book = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book.save()
    test_patron = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron.save()
    test_patron.check_out(test_book)
    expect(test_book.checkout()).to(eq(Date.today().to_s()))
  end
  
  it('sets is_checked_out to true') do
    test_book = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book.save()
    test_patron = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron.save()
    test_patron.check_out(test_book)
    expect(test_book.is_checked_out()).to(eq(true))
  end
  
  it('returns false when the book is already checked out') do
    test_book = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book.save()
    test_patron1 = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron1.save()
    test_patron2 = @@create_patron.call({:last_name => "Doe", :first_name => "Jane"})
    test_patron2.save()
    test_patron1.check_out(test_book)
    expect(test_patron2.check_out(test_book)).to(eq(false))
  end
  
  it('does not assign a book to a patron when the book is already checked out') do
    test_book = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book.save()
    test_patron1 = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron1.save()
    test_patron2 = @@create_patron.call({:last_name => "Doe", :first_name => "Jane"})
    test_patron2.save()
    test_patron1.check_out(test_book)
    test_patron2.check_out(test_book)
    expect(test_book.patron_id()).to(eq(test_patron1.id()))
  end
end

describe('#books') do
  it('provides a list of books currently checked out') do
    test_book1 = @@create_book.call({})
    test_book2 = @@create_book.call({})
    test_book3 = @@create_book.call({})
    test_book4 = @@create_book.call({})
    test_book1.save()
    test_book2.save()
    test_book3.save()
    test_book4.save()
    test_patron = @@create_patron.call({})
    test_patron.save()
    test_patron.check_out(test_book1)
    test_patron.check_out(test_book2)
    test_patron.check_out(test_book3)
    expect(test_patron.books()).to(eq([test_book1, test_book2, test_book3]))
  end
end

describe('#checkout_history') do
  it('provides a list of books checked out by the patron regardless of whether they are still checked out or returned') do
    test_book1 = @@create_book.call({})
    test_book2 = @@create_book.call({})
    test_book3 = @@create_book.call({})
    test_book4 = @@create_book.call({})
    test_book5 = @@create_book.call({})
    test_book6 = @@create_book.call({})
    test_book1.save()
    test_book2.save()
    test_book3.save()
    test_book4.save()
    test_book5.save()
    test_book6.save()
    test_patron = @@create_patron.call({})
    test_patron.save()
    test_patron.check_out(test_book1)
    test_patron.return(test_book1)
    test_patron.check_out(test_book2)
    test_patron.check_out(test_book3)
    expect(test_patron.checkout_history()).to(eq([test_book1, test_book2, test_book3]))
  end
end

describe('#overdue') do
  it('provides a list of overdue books') do
    test_book1 = @@create_book.call({})
    test_book2 = @@create_book.call({})
    test_book3 = @@create_book.call({})
    test_book1.save()
    test_book2.save()
    test_book3.save()
    test_patron = @@create_patron.call({})
    test_patron.save()
    test_patron.check_out(test_book1)
    test_patron.check_out(test_book2)
    test_patron.check_out(test_book3)
    test_book1.update({:checkout => Date.new(1991, 8, 6)})
    test_book2.update({:checkout => Date.new(1991, 8, 6)})
    expect(test_patron.overdue()).to(eq([test_book1, test_book2]))
  end
end

describe('#return') do
  it('dissociates a book from the patron') do
    test_book = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book.save()
    test_patron = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron.save()
    test_patron.check_out(test_book)
    test_patron.return(test_book)
    expect(test_book.patron_id()).to(eq(0))
  end
  
  it('updates the status of a book to not checked out') do
    test_book = @@create_book.call({:title => "Social Sciences as Sorcery"})
    test_book.save()
    test_patron = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron.save()
    test_patron.check_out(test_book)
    test_patron.return(test_book)
    expect(test_book.is_checked_out()).to(eq(false))
  end
end

describe('#save') do
  it('saves a patron') do
    test_patron = @@create_patron.call({})
    test_patron.save()
    expect(Patron.all()).to(eq([test_patron]))
  end
end

describe('#delete') do
  it('deletes a patron') do
    test_patron1 = @@create_patron.call({})
    test_patron1.save()
    test_patron2 = @@create_patron.call({})
    test_patron2.save()
    test_patron2.delete()
    expect(Patron.all()).to(eq([test_patron1]))
   end
end

describe('#update') do
  it('updates the last name') do
    test_patron = @@create_patron.call({:last_name => "King"})
    test_patron.save()
    test_patron.update({:last_name => "Andreski"})
    expect(Patron.find(test_patron.id()).last_name()).to(eq("Andreski"))
  end
  
  it('updates the first name') do
    test_patron = @@create_patron.call({:first_name => "Stephen"})
    test_patron.save()
    test_patron.update({:first_name => "Stanislav"})
    expect(Patron.find(test_patron.id()).first_name()).to(eq("Stanislav"))
  end
  
  it('update first and last names') do
    test_patron = @@create_patron.call({:first_name => "Stephen"})
    test_patron.save()
    test_patron.update({:last_name => "Andreski", :first_name => "Stanislav"})
    expect(Patron.find(test_patron.id()).last_name()).to(eq("Andreski"))
    expect(Patron.find(test_patron.id()).first_name()).to(eq("Stanislav"))
  end
end

describe('.all') do
  it('starts as an empty array') do
    expect(Patron.all()).to(eq([]))
  end
end

describe('.find') do
  it('finds a patron based on their id') do
    test_patron1 = @@create_patron.call({})
    test_patron1.save()
    test_patron2 = @@create_patron.call({})
    test_patron2.save()
    expect(Patron.find(test_patron1.id())).to(eq(test_patron1))
  end
end

describe('.search_by') do
  it('finds patrons based on a single criterion') do
    test_patron1 = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron2 = @@create_patron.call({:last_name => "Doe", :first_name => "Jane"})
    test_patron1.save()
    test_patron2.save()
    expect(Patron.search_by({:last_name => "Smith"})).to(eq([test_patron1]))
  end
  
  it('returns multiple matching patrons') do
    test_patron1 = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron2 = @@create_patron.call({:last_name => "Smith", :first_name => "Jon"})
    test_patron1.save()
    test_patron2.save()
    expect(Patron.search_by({:last_name => "Smith"})).to(eq([test_patron1, test_patron2]))
  end
  
  it('finds patrons based on multiple criteria') do
    test_patron1 = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron2 = @@create_patron.call({:last_name => "Smith", :first_name => "Jon"})
    test_patron1.save()
    test_patron2.save()
    expect(Patron.search_by({:last_name => "Smith", :first_name => "John"})).to(eq([test_patron1]))
  end
  
  it('returns false if a single criterion does not match') do
    test_patron1 = @@create_patron.call({:last_name => "Smith", :first_name => "John"})
    test_patron2 = @@create_patron.call({:last_name => "Smith", :first_name => "Jon"})
    test_patron1.save()
    test_patron2.save()
    expect(Patron.search_by({:last_name => "Smith", :first_name => "Jawn"})).to(eq(false))
  end
end

describe('#==') do
  it('compares patrons based on their first and last names') do
    test_patron1 = @@create_patron.call({:last_name => "Nelson", :first_name => "Prince"})
    test_patron2 = @@create_patron.call({:last_name => "Nelson", :first_name => "Prince"})
    expect(test_patron1 == test_patron2).to(eq(true))
  end
end