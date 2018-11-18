import 'package:crust/modules/auth/models/user.dart';
import 'package:crust/modules/home/models/store.dart';
import 'package:crust/modules/post/models/Post.dart';
import 'package:crust/services/toaster.dart';

class PostRepository {
  const PostRepository();

  Future<List<Post>> fetchPostsByUserAccountId(int userAccountId) async {
    String query = """
    query {
      postsByUserAccountId(
        userAccountId: $userAccountId
      ) {
        post {
          id,
          type,
          store {
            id,
            name,
            cover_image,
          },
          posted_by{
            id,
            profile {
              username,
              display_name,
              profile_picture,
            }
          },
          posted_at,
          post_photos {
            id,
            photo,
          },
          post_review {
            id,
            overall_score,
            taste_score,
            service_score,
            value_score,
            ambience_score,
            body,
          },
        }
        }
      }
    }
  """;
    final response = await Toaster.get(query);
    if (response['postsByUserAccountId'] != null) {
      return (response['postsByUserAccountId'] as List).map((post) {
        var store = post['store'];
        var postedBy = post['posted_by'];
        var postPhotos = post['post_photos'];
        var postReview = post['post_review'];
        Post(
          id: post['id'],
          type: post['type'],
          store: Store(
            id: store['id'],
            name: store['name'],
            coverImage: store['cover_image'],
          ),
          postedBy: User(
            id: postedBy['id'],
            username: postedBy['profile']['username'],
            fullName: postedBy['profile']['display_name'],
            picture: postedBy['profile']['profile_picture'],
          ),
          postedAt: DateTime.parse(post['postedAt']),
          postPhotos: (postPhotos as List).map((postPhoto) => PostPhoto(
            id: postPhoto['id'],
            photo: postPhoto['photo'],
          )),
          postReview: PostReview(
            id: postReview['id'],
            overallScore: postReview['overall_score'],
            ambienceScore: postReview['ambience_score'],
            serviceScore: postReview['service_score'],
            tasteScore: postReview['taste_score'],
            valueScore: postReview['value_score'],
            body: postReview['id'],
          )
        );
      }
      ).toList();
    } else {
      throw Exception('Failed');
    }
  }


}
