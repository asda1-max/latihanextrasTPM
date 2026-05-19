enum SnapiCategory {
  news,
  blog,
  report,
}

extension SnapiCategoryX on SnapiCategory {
  String get title {
    switch (this) {
      case SnapiCategory.news:
        return 'News';
      case SnapiCategory.blog:
        return 'Blog';
      case SnapiCategory.report:
        return 'Report';
    }
  }

  String get description {
    switch (this) {
      case SnapiCategory.news:
        return 'Get an overview of the latest SpaceFlight news, from various sources! Easily link your users to the right websites.';
      case SnapiCategory.blog:
        return 'Blogs often provide a more detailed overview of launches and missions. A must-have for the serious spaceflight enthusiast.';
      case SnapiCategory.report:
        return 'Space stations and other missions often publish their data. With SNAPI, you can include it in your app.';
    }
  }

  String get endpoint {
    switch (this) {
      case SnapiCategory.news:
        return 'https://api.spaceflightnewsapi.net/v4/articles/';
      case SnapiCategory.blog:
        return 'https://api.spaceflightnewsapi.net/v4/blogs/';
      case SnapiCategory.report:
        return 'https://api.spaceflightnewsapi.net/v4/reports/';
    }
  }
}
