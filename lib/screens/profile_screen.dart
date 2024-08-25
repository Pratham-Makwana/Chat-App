import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/apis/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import '../model/chat_user.dart';

/// profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    /// initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    return Scaffold(
      /// AppBar
      appBar: AppBar(
        title: const Text(
          "Chat App",
        ),
      ),

      /// floating action button to add user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          label: const Text(
            "Logout",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          icon: const Icon(
            Icons.login_outlined,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.height * .03),
          child: Column(
            children: [
              /// For adding some space
              SizedBox(
                width: mq.width,
                height: mq.height * .05,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .1),
                child: CachedNetworkImage(
                  height: mq.height * .2,
                  width: mq.height * .2,
                  fit: BoxFit.fill,
                  imageUrl : widget.user.image,
                  //imageUrl: 'https://imgs.search.brave.com/WFiTFcSi2_uNMo5T034sJyD6x7tVkY1nBmdnTRLknp4/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMTQw/NzA4NDQxOS9waG90/by9wb3J0cmFpdC1v/Zi1oYXBweS1tYXR1/cmUtd29tZW4uanBn/P3M9NjEyeDYxMiZ3/PTAmaz0yMCZjPVRW/ak5iSHlyU1ZKN1hj/VFpONi1sSG1JdEhJ/RjB2VnpjSXZPWXlY/QVBwOGs9',
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
        
              /// For adding some space
              SizedBox(
                height: mq.height * .03,
              ),

              /// user email label
              Text(
                widget.user.email,
                style: const TextStyle(fontSize: 16, color: Colors.black87

                ),
              ),
        
              /// For adding some space
              SizedBox(
                height: mq.height * .05,
              ),

              /// name input filed
              TextFormField(
                initialValue: widget.user.name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: const Text("Name"),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.black,
                    )),
              ),
        
              /// For adding some space
              SizedBox(
                height: mq.height * .02,
              ),

              /// about input field
              TextFormField(
                initialValue: widget.user.about,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    label: const Text("About"),
                    prefixIcon: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    )),
              ),
        
              /// For adding some space
              SizedBox(
                height: mq.height * .02,
              ),

              /// update profile button
              ElevatedButton.icon(
                style:ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, mq.height * .06),
                  backgroundColor: Colors.deepPurple.shade500
                ),
                  onPressed: () {},
                  icon: const Icon(Icons.edit,color: Colors.white,size: 24,),
                  label: const Text('Update',style: TextStyle(color: Colors.white,fontSize: 16),))
            ],
          ),
        ),
      ),
    );
  }
}
