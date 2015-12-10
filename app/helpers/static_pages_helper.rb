module StaticPagesHelper
end

class ApplicationController
  semantic_breadcrumb :index, :root_path
end

class ExamplesController < ApplicationController
  semantic_breadcrumb :index, :examples_path

  def index
  end

  def show
    @example = Example.find params[:id]
    semantic_breadcrumb @example.name, example_path(@example)
    # semantic_breadcrumb :show, example_path(@example)
  end
end