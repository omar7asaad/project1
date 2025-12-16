// view/waiting_approval_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:build/routes/app_routes.dart';
import 'package:build/utils/app_colors.dart';

class WaitingApprovalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        
        
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        
        child: Stack(
          children: [
            
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/waiting_background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            ),
            
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24),
                
               
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Container(
                      padding: EdgeInsets.all(30),
                      
                      decoration: BoxDecoration(
                        
                        color: Color(0x33FF9800),  
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0x4DFF9800), 
                          width: 2,
                        ),
                      ),
                      
                      child: Icon(
                        Icons.hourglass_top,
                        size: 80,
                        color: Colors.orange,
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    Text(
                      'تم إرسال طلب التسجيل!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: 20),
                    
                  
                    Text(
                      'شكراً لتسجيلك في تطبيق عقاراتي',
                      style: TextStyle(
                        color: AppColors.skyBlue,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: 30),
                    
                    Container(
                      padding: EdgeInsets.all(20),
                      
                      decoration: BoxDecoration(
                        color: Color(0x331565C0),  
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0x4D64B5F6),  
                        ),
                      ),
                      
                      child: Column(
                        children: [
                         
                          Icon(
                            Icons.admin_panel_settings,
                            color: AppColors.skyBlue,
                            size: 40,
                          ),
                          
                          SizedBox(height: 16),
                          
                          
                          Text(
                            'طلبك قيد المراجعة من قبل مدير النظام',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          SizedBox(height: 12),
                          
                         
                          Text(
                            'سيتم إخطارك عند الموافقة على حسابك. قد تستغرق عملية المراجعة من 24 إلى 48 ساعة.',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.login);
                      },
                      
                      child: Text(
                        'العودة لتسجيل الدخول',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.support_agent, color: Colors.white54, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'للاستفسارات تواصل مع الدعم الفني',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

