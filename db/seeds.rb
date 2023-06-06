require 'csv'

# Read the CSV file
csv_data = CSV.read('data.csv', headers: true)

User.destroy_all
Book.destroy_all
Review.destroy_all

puts "🌱 Seeding spices..."

# Seed your database here
# users
ase = User.create(name:'Ted Lasso')
ase = User.create(name:'Roy Kent')
ase = User.create(name:'Keeley Jone')
ase = User.create(name:'Rebecca Walton')
ase = User.create(name:'Nathan Shelly')
ase = User.create(name:'Jamie Tartt')
ase = User.create(name:'Zava')
ase = User.create(name:'Shandy Fine')
ase = User.create(name:'Nora')
ase = User.create(name:'Tabitha')

# Books
csv_data.each do |row|
  # Extract the data from each column
  image = row['image']
  title = row['name']
  author = row['author']
  price = row['price'].to_f
  category = row['category']
  synopsis = row['synopsis']

  # Create a book instance
  book = Book.create(
    image: image,
    title: title,
    author: author,
    price: price,
    genre: category,
    synopsis: synopsis
  )

  # Save the book instance
  book.save

  rand(1..5).times do
    # get a random user for every review
    # https://stackoverflow.com/a/25577054
    user = User.order('RANDOM()').first

    # A review belongs to a game and a user, so we must provide those foreign keys
    Review.create(
      rating: rand(1..10),
      comment: Faker::Lorem.sentence,
      book_id: book.id,
      user_id: user.id
    )
  end
end


puts "✅ Done seeding!"
