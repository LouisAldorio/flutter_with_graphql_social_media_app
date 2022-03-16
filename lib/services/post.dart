String getPosts = """
  query getPosts(\$page: Int!, \$limit: Int!) {
    posts(pagination: {
      limit: \$limit
      page: \$page
    }) {
      totalPages
      count
      currentPage
      data {
        id
        title
        body
        author {
          id
          name
        }
        comments{
          id
          body
          author {
            id
            name
          }
        }
      }
    }
  }
""";