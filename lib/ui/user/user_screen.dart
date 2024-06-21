
import 'package:flutter/material.dart';
import 'package:myshop/ui/shared/app_drawer.dart';
import 'package:myshop/ui/user/user_manager.dart';
import 'package:provider/provider.dart';

import '../auth/auth_manager.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user';

  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final userManager = Provider.of<UserManager>(context);
    // final userProfile = userManager.profile;
    final user = context.read<UserManager>();
    return Scaffold(
        appBar: AppBar(
        title: const Text('Thông tin người dùng'),
    ),
    drawer: const AppDrawer(),
    body: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
    SizedBox(
    height: 200, // Kích thước hình ảnh người dùng
    child: Center(
    child: CircleAvatar(
    radius: 80, // Đường kính hình tròn
    backgroundImage: NetworkImage(
    'https://cdn-icons-png.flaticon.com/512/149/149071.png', // Đường dẫn đến hình ảnh người dùng
    ),
    ),
    ),
    ),
    const SizedBox(height: 20), // Khoảng cách giữa hình ảnh và thông tin người dùng

    // Hiển thị thông tin người dùng
      _buildUserInfoItem('Tên:', user?.profile?.name ?? 'Không có thông tin'),
      _buildUserInfoItem('Email:', user?.profile?.email ?? 'Không có thông tin'),
      _buildUserInfoItem('Địa chỉ:', user?.profile?.address ?? 'Không có thông tin'),
      _buildUserInfoItem('Số điện thoại:', user?.profile?.phone ?? 'Không có thông tin'),
      const SizedBox(height: 20), // Khoảng cách giữa thông tin người dùng và nút logout
      ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/');
          context.read<AuthManager>().logout();
        },
        icon: Icon(Icons.logout),
        label: Text('Đăng Xuất'),
      ),
    ],
    ),
    );
  }

  Widget _buildUserInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(width: 10), // Khoảng cách giữa tiêu đề và giá trị
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 24),
            ),
          ),

        ],
      ),
    );
  }
}
