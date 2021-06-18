const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.onFollowUser = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onCreate(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // Increase followed user's follower count
    const followedUserRef = admin.firestore().collection("users").doc(userId);
    const followedUserDoc = await followedUserRef.get();
    if (followedUserDoc.get("followers") !== undefined) {
      followedUserRef.update({
        followers: followedUserDoc.get("followers") + 1,
      });
    } else {
      followedUserRef.update({ followers: 1 });
    }

    // Increase user's following count
    const userRef = admin.firestore().collection("users").doc(followerId);
    const userDoc = await userRef.get();
    if (userDoc.get("following") !== undefined) {
      userRef.update({ following: userDoc.get("following") + 1 });
    } else {
      userRef.update({ following: 1 });
    }

    // Add followed user's post to user's post feed
    const followedUserPostRef = admin
      .firestore()
      .collection("posts")
      .where("author", "==", followedUserRef);

    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed");

    const followedUserPostsSnapshot = await followedUserPostRef.get();
    followedUserPostsSnapshot.forEach((doc) => {
      if (doc.exists) {
        userFeedRef.doc(doc.id).set(doc.data());
      }
    });
  });

exports.onUnfollowUser = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onDelete(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // Decrease unfollowed user's follower count
    const followedUserRef = admin.firestore().collection("users").doc(userId);
    const followedUserDoc = await followedUserRef.get();
    if (followedUserDoc.get("followers") !== undefined) {
      followedUserRef.update({
        followers: followedUserDoc.get("followers") - 1,
      });
    } else {
      followedUserRef.update({ followers: 0 });
    }

    // Decrement user's following count
    const userRef = admin.firestore().collection("users").doc(followerId);
    const userDoc = await userRef.get();
    if (userDoc.get("following") !== undefined) {
      userRef.update({ following: userDoc.get("following") - 1 });
    } else {
      userRef.update({ following: 0 });
    }

    // Remove unfollowed user's posts from user's post feed
    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed")
      .where("author", "==", followedUserRef);
    const userPostsSnapshot = await userFeedRef.get();
    userPostsSnapshot.forEach((doc) => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onCreatePost = functions.firestore
  .document("/posts/{postId}")
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;

    // Getting author id
    const authorRef = snapshot.get("author");
    const authorId = authorRef.path.split("/")[1];

    //Add new post to feed of all followers
    const userFollowRef = admin
      .firestore()
      .collection("followers")
      .doc(authorId)
      .collection("userFollowers");

    const userFollowersSnapshots = await userFollowRef.get();
    userFollowersSnapshots.forEach((doc) => {
      admin
        .firestore()
        .collection("feeds")
        .doc(doc.id)
        .collection("userFeed")
        .doc(postId)
        .set(snapshot.data());
    });
  });
