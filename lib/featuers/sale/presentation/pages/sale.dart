import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/services/dependencies.dart';
import '../bloc/sell_car_bloc.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCarType = 'سيدان';
  String _selectedTransmission = 'أوتوماتيك';
  List<XFile> _selectedImages = [];

  List<String> carTypes = ['سيدان', 'SUV', 'هايبرد', 'كهربائية', 'كلاسيكية'];
  List<String> transmissions = ['أوتوماتيك', 'مانوال'];

  @override
  void dispose() {
    _carModelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellCarBloc, SellCarState>(
      bloc: getIt<SellCarBloc>(),
      listener: (context, state) {
        if (state is SellCarSuccess) {
          _showSuccessDialog();
        } else if (state is SellCarFailure) {
          _showErrorDialog(state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بيع سيارتي'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                _showSellingTips();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // قسم رفع الصور
                _buildImageUploadSection(),
                const SizedBox(height: 20),

                // معلومات السيارة الأساسية
                _buildSectionTitle('معلومات السيارة'),
                _buildCarInfoForm(),

                // تفاصيل إضافية
                _buildSectionTitle('تفاصيل إضافية'),
                _buildAdditionalDetails(),

                // معلومات الاتصال
                _buildSectionTitle('معلومات الاتصال'),
                _buildContactInfo(),

                // زر النشر
                _buildPublishButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صور السيارة (5 كحد أقصى)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _selectedImages.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                File(_selectedImages[index].path),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                            child: const Icon(Icons.cancel, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_photo_alternate, size: 40),
                        onPressed: _pickImages,
                      ),
                      const Text(
                        'إضافة صور',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
        ),
        if (_selectedImages.isNotEmpty && _selectedImages.length < 5)
          TextButton(
            onPressed: _pickImages,
            child: const Text('+ إضافة المزيد من الصور'),
          ),
      ],
    );
  }

  Widget _buildCarInfoForm() {
    return Column(
      children: [
        TextFormField(
          controller: _carModelController,
          decoration: const InputDecoration(
            labelText: 'الموديل والماركة',
            prefixIcon: Icon(Icons.directions_car),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال الموديل والماركة';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'سنة الصنع',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال سنة الصنع';
                  }
                  if (int.tryParse(value) == null) {
                    return 'سنة غير صالحة';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'السعر (ر.س)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال السعر';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalDetails() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedCarType,
          decoration: const InputDecoration(
            labelText: 'نوع السيارة',
            prefixIcon: Icon(Icons.category),
            border: OutlineInputBorder(),
          ),
          items: carTypes.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedCarType = newValue!;
            });
          },
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: _selectedTransmission,
          decoration: const InputDecoration(
            labelText: 'نوع القير',
            prefixIcon: Icon(Icons.settings),
            border: OutlineInputBorder(),
          ),
          items: transmissions.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedTransmission = newValue!;
            });
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'وصف إضافي (اختياري)',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'رقم الجوال',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال رقم الجوال';
            }
            if (value.length < 10) {
              return 'رقم غير صالح';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'المدينة',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال المدينة';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPublishButton() {
    return BlocBuilder<SellCarBloc, SellCarState>(
      bloc: getIt<SellCarBloc>(),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: state is SellCarLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitCarForSale();
                      }
                    },
                    child: const Text(
                      'نشر الإعلان',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          // Limit to 5 images maximum
          int remainingSlots = 5 - _selectedImages.length;
          if (remainingSlots > 0) {
            _selectedImages.addAll(pickedFiles.take(remainingSlots));
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick images: $e')));
    }
  }

  void _submitCarForSale() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء إضافة صورة واحدة على الأقل')),
        );
        return;
      }

      final sellCarBloc = getIt<SellCarBloc>();

      sellCarBloc.add(
        SubmitCarListingEvent(
          carModel: _carModelController.text,
          year: int.parse(_yearController.text),
          price: double.parse(_priceController.text),
          phone: _phoneController.text,
          carType: _selectedCarType,
          transmission: _selectedTransmission,
          description: _descriptionController.text,
          city: _cityController.text,
          imageFiles: _selectedImages,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم بنجاح'),
        content: const Text(
          'تم إرسال طلب بيع سيارتك بنجاح، سنتواصل معك قريباً.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text('فشل في إرسال الطلب: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showSellingTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نصائح لبيع أسرع'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• استخدم صوراً واضحة وجيدة الإضاءة'),
              SizedBox(height: 8),
              Text('• اذكر جميع المواصفات والمشاكل إن وجدت'),
              SizedBox(height: 8),
              Text('• حدد سعراً مناسباً حسب السوق'),
              SizedBox(height: 8),
              Text('• كن متاحاً للرد على الاستفسارات'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('شكراً'),
          ),
        ],
      ),
    );
  }
}
