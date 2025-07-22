import 'dart:io';

import 'package:financial_ai_mobile/controller/chat_controller.dart';
import 'package:financial_ai_mobile/core/helper/widget_helper.dart';
import 'package:financial_ai_mobile/core/models/chat_model.dart';
import 'package:financial_ai_mobile/core/utils/app_icons.dart';
import 'package:financial_ai_mobile/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AiChatScreen extends StatelessWidget {
  AiChatScreen({super.key});
  final ChatController chatController = Get.put(ChatController());
  final ScrollController _scrollController = ScrollController();

  // Function to scroll to the bottom of the chat list
  void _scrollToBottom() {
    // Check if the scroll controller is attached to a view
    if (_scrollController.hasClients) {
      // Animate to the maximum scroll extent (the end of the list)
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      // This property is crucial. It makes the body resize when the keyboard appears.
      resizeToAvoidBottomInset: true,
      appBar: WidgetHelper.showAppBar(
        isBack: true,
        title: 'AI Financial Assistant',
        isCenter: false,
        showActions: false,
      ),
      // *** MODIFICATION START ***
      // The body is now a Column to hold the chat list and the input field together.
      // This is the standard and most reliable way to build a chat UI.
      body: Column(
        children: [
          // The Expanded widget ensures the chat list takes up all available
          // space, pushing the input field to the bottom.
          Expanded(
            child: Obx(() {
              // This callback scrolls to the bottom after the UI has been rebuilt
              // with a new message.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
              // Show the welcome text if the chat is empty, otherwise show the list.
              return chatController.chatData.isEmpty
                  ? _buildWelcomeText()
                  : _buildChatList();
            }),
          ),
          // The loading indicator is part of the Column and will appear
          // just above the input field.
          Obx(() {
            return chatController.isLoading.value
                ? Padding(
                  padding: EdgeInsets.all(10.r),
                  child: SizedBox(
                    width: double.infinity,
                    height: 20.h,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade200,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                )
                : const SizedBox.shrink();
          }),
          // The message input field is now the last widget in the Column.
          // When the keyboard appears, the Column resizes, and this widget
          // will be pushed up, remaining visible.
          _buildMessageInput(),
        ],
      ),
      // *** MODIFICATION END ***
      // The bottomNavigationBar is no longer needed here because the input field
      // has been moved into the body.
      // bottomNavigationBar: _buildMessageInput(),
    );
  }

  Widget _buildWelcomeText() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome to Your Personal',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 5.h),
          Text(
            'AI Financial Assistant!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ListView.builder(
        controller: _scrollController, // Assign the scroll controller
        itemCount: chatController.chatData.length,
        itemBuilder: (context, index) {
          final message = chatController.chatData[index];
          return _buildMessageCard(message, context);
        },
      ),
    );
  }

  Widget _buildMessageCard(ChatModel message, BuildContext context) {
    bool isSender = message.isSender;
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.all(10.w),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isSender ? AppStyles.blueColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSender && message.imageFile != null)
              Padding(
                padding: EdgeInsets.only(
                  bottom: message.message.isNotEmpty ? 8.h : 0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    message.imageFile!,
                    width: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            if (message.message.isNotEmpty)
              isSender
                  ? Text(
                    message.message,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  )
                  : md.MarkdownBody(
                    selectable: true,
                    data: message.message,
                    styleSheet: md.MarkdownStyleSheet(
                      p: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    // This container wraps the entire input section.
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      // SafeArea ensures the input field avoids system intrusions at the bottom (like the home bar).
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return chatController.selectedImage.value != null
                  ? _buildSelectedImagePreview()
                  : const SizedBox.shrink();
            }),
            _buildInputRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(
                  chatController.selectedImage.value!,
                  width: 60.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -5,
                right: -5,
                child: GestureDetector(
                  onTap: () {
                    chatController.removeImage();
                  },
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5.w),
                    ),
                    child: Icon(Icons.close, size: 12.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: TextField(
              controller: chatController.chatTextController,
              maxLines: 5,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Message AI Financial Assistant...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
              onTap: () {
                // When the text field is tapped, ensure the view scrolls
                // to the end after a short delay to account for the keyboard animation.
                Future.delayed(
                  const Duration(milliseconds: 300),
                  _scrollToBottom,
                );
              },
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () async {
            await chatController.pickImage();
          },
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: SvgPicture.asset(
              AppIcons.addImage,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                Colors.grey.shade700,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (!chatController.isLoading.value) {
              await chatController.sendMessage();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Obx(
              () =>
                  chatController.isLoading.value
                      ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      )
                      : SvgPicture.asset(
                        AppIcons.sendIcon,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                          AppStyles.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }
}
