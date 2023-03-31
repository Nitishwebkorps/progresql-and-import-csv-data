class PostsController < ApplicationController
  require 'csv'
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    
    @posts = Post.paginate(page: params[:page])
  end

  def import
    file = params[:file]
    return redirect_to posts_path, notice: 'only CSV File to be supported' unless file.content_type == 'text/csv'
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ";")
    csv.each do |row|
      post_hash = {}
      post_hash[:title] = row['title']
      post_hash[:body] = row['body']
      Post.create(post_hash)
    end
    redirect_to posts_path, notice: 'File imported successfully'
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  def sort 
  end

  def rast
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
