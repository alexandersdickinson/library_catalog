require('spec_helper')

@@create_patron = lambda do |attributes|
  base = {:last_name => '', :first_name => '', :id => nil}
  base.merge!(attributes)
  Patron.new(base)
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

describe('#==') do
  it('compares patrons based on their first and last names') do
    test_patron1 = @@create_patron.call({:last_name => "Nelson", :first_name => "Prince"})
    test_patron2 = @@create_patron.call({:last_name => "Nelson", :first_name => "Prince"})
    expect(test_patron1 == test_patron2).to(eq(true))
  end
end