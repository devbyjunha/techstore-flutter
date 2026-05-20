import 'package:flutter/material.dart';

class CategoryInfo {
  final String name;
  final String slug;
  final List<Color> gradient;

  const CategoryInfo({
    required this.name,
    required this.slug,
    required this.gradient,
  });
}

const List<CategoryInfo> homeCategories = [
  CategoryInfo(
    name: '노트북',
    slug: 'laptop',
    gradient: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
  ),
  CategoryInfo(
    name: '스마트폰',
    slug: 'smartphone',
    gradient: [Color(0xFF8B5CF6), Color(0xFF9333EA)],
  ),
  CategoryInfo(
    name: '태블릿',
    slug: 'tablet',
    gradient: [Color(0xFF06B6D4), Color(0xFF2563EB)],
  ),
  CategoryInfo(
    name: '액세서리',
    slug: 'accessory',
    gradient: [Color(0xFFF59E0B), Color(0xFFEA580C)],
  ),
];

const List<CategoryInfo> navCategories = [
  CategoryInfo(name: '노트북', slug: 'laptop', gradient: []),
  CategoryInfo(name: '스마트폰', slug: 'smartphone', gradient: []),
  CategoryInfo(name: '태블릿', slug: 'tablet', gradient: []),
  CategoryInfo(name: '액세서리', slug: 'accessory', gradient: []),
];
