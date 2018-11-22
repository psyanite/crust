import 'package:crust/modules/auth/models/user.dart';
import 'package:crust/modules/home/models/store.dart';
import 'package:crust/modules/post/models/Post.dart';
import 'package:crust/services/toaster.dart';
import 'package:crust/utils/enum_util.dart';

class PostRepository {
  const PostRepository();

  Future<List<Post>> fetchPostsByUserAccountId(int userAccountId) async {
    String query = """
    query {
      postsByUserAccountId(
        userAccountId: $userAccountId
      ) {
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
          taste_score,
          service_score,
          value_score,
          ambience_score,
          body,
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
        return Post(
            id: post['id'],
            type: EnumUtil.fromString(PostType.values, post['type']),
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
            postedAt: DateTime.parse(post['posted_at']),
            postPhotos: (postPhotos as List).map((postPhoto) => PostPhoto(
                  id: postPhoto['id'],
                  photo: postPhoto['photo'],
                )).toList(),
            postReview: postReview == null ? null : PostReview(
              id: postReview['id'],
              ambienceScore: EnumUtil.fromString(Score.values, postReview['ambience_score']),
              serviceScore: EnumUtil.fromString(Score.values, postReview['service_score']),
              tasteScore: EnumUtil.fromString(Score.values, postReview['taste_score']),
              valueScore: EnumUtil.fromString(Score.values, postReview['value_score']),
              body: postReview['body'],
            ));
      }).toList();
    } else {
      throw Exception('Failed');
    }
  }
}
