require File.dirname(__FILE__) + '/../spec_helper'

module Semantic
  describe Search do

    documents = ["The cat in the hat disabled", "A cat is a fine pet ponies.", "Dogs and cats make good pets.","I haven't got a hat."]

    def mock_builder
      @builder ||= mock(VectorSpace::Builder)
    end

    def mock_matrix_transformer
      @matrix_transformer ||= mock(MatrixTransformer)
    end

    def vector_space
      @vector_space ||= Linalg::DMatrix.rows([[0,1],[1,0]])
    end

    def query_vector
      @query_vector ||= Linalg::DMatrix.rows([[1,0]])
    end

    def matrix(array)
      Linalg::DMatrix.rows(array)
    end

    describe "setting up" do

      it "should build the vector space" do
        VectorSpace::Builder.stub!(:new).and_return(mock_builder)
        mock_builder.should_receive(:build_document_matrix).with(['test']).and_return(vector_space)

        Search.new(['test'])
      end

      it "should transform matrices" do
        MatrixTransformer.stub!(:new).and_return(mock_matrix_transformer)
        mock_matrix_transformer.should_receive(:apply_transforms).with(matrix([[1]])).and_return(matrix([[1]]))

        Search.new(['test'])
      end

    end

    describe "searching" do

      it "should map search term to vector space" do
        VectorSpace::Builder.stub!(:new).and_return(mock_builder)
        mock_builder.stub!(:build_document_matrix).and_return(vector_space)
        mock_builder.should_receive(:build_query_vector).with("cat").and_return(query_vector)

        vector_search = Search.new(documents)
        vector_search.search("cat")
      end

      it "should compare the documents using cosine" do
        pending
      end

    end

    describe "relating" do

      it "should find related documents by comparing cosine" do
        VectorSpace::Builder.stub!(:new).and_return(mock_builder)
        mock_builder.stub!(:build_document_matrix).and_return(vector_space)

        MatrixTransformer.stub!(:new).and_return(mock_matrix_transformer)
        mock_matrix_transformer.stub!(:apply_transforms).and_return(vector_space)

        Compare.should_receive(:cosine).with(vector_space.row(0), vector_space.row(0))
        Compare.should_receive(:cosine).with(vector_space.row(0), vector_space.row(1))

        vector_search = Search.new(documents)
        vector_search.related(0)
      end

    end

  end
end
