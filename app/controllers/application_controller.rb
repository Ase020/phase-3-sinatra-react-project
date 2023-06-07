class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "Welcome to aseBooksstore!" }.to_json
  end

  get '/books' do
    Book.all.to_json(only: [:id, :title, :genre, :author, :image, :price, :synopsis], include: {
      reviews: {only: [:comment, :rating], include: {
        user: {only: [:name]}
      }}
    })
  end

  post '/books' do
    book_data = JSON.parse(request.body.read)

    book = Book.new(
      title: book_data['title'],
      author: book_data['author'],
      price: book_data['price'],
      genre: book_data['genre'],
      image: book_data['image'],
      synopsis: book_data['synopsis'],
    )

    if book.save
      status 201
      book.to_json
    else
      status 500
      { error: "Error! Book save failed 💀"}.to_json
    end
  end

  get '/books/:id' do
    # book = Book.all.find_by(:id)
    Book.all.find(params[:id]).to_json(only: [:id, :title, :genre, :author, :image, :synopsis, :price], include: {
      reviews: {only: [:id, :comment, :rating], include: {
        user: {only: [:name]}
      }}
    })
  end

  patch '/books/:id' do
    updated_book = JSON.parse(request.body.read)

    book = Book.find(params[:id])
    if book
      book.update(updated_book)
      status 200
      { message: 'Book updated successfully', book: book }.to_json
    else
      status 404
      { message: 'Book not found' }.to_json
    end
  end

end
