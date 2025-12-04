import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../models/course_model.dart';

/// Carte de cours avec design moderne et animations fluides
class CourseCard extends StatefulWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  final CourseModel course;
  final VoidCallback onTap;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(24),
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_isHovered ? 0.98 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? Color(0xFF667EEA).withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isHovered ? 24 : 12,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail avec gradient overlay
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Stack(
                  children: [
                    // Image du cours
                    Container(
                      height: 180,
                      width: double.infinity,
                      child: widget.course.thumbnail != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                              child: Image.network(
                                widget.course.thumbnail!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF667EEA),
                                          Color(0xFF764BA2),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : _buildPlaceholder(),
                    ),
                    // Gradient overlay moderne avec effet de profondeur
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Overlay supplémentaire pour effet moderne
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF667EEA).withOpacity(0.1),
                              Colors.transparent,
                              Color(0xFF764BA2).withOpacity(0.1),
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Badge niveau
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getLevelIcon(widget.course.level),
                              size: 14,
                              color: Color(0xFF667EEA),
                            ),
                            SizedBox(width: 4),
                            Text(
                              _getLevelText(widget.course.level),
                              style: AppTextStyles.captionSmall.copyWith(
                                color: Color(0xFF667EEA),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 400.ms)
                          .scale(delay: 200.ms, duration: 400.ms),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.course.title,
                      style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    // Instructor
                    if (widget.course.instructorName != null)
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.course.instructorName!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    SizedBox(height: AppSpacing.sm),
                    // Stats row
                    Row(
                      children: [
                        // Rating
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF4E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: Color(0xFFFFB800),
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.course.rating.toStringAsFixed(1),
                                style: AppTextStyles.captionSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFB800),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        // Lesson count
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_outline_rounded,
                                size: 14,
                                color: Color(0xFF667EEA),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${widget.course.lessonCount}',
                                style: AppTextStyles.captionSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF667EEA),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        // Arrow icon
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        )
                            .animate()
                            .scale(delay: 100.ms, duration: 300.ms)
                            .shimmer(delay: 200.ms, duration: 1000.ms),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCourseIcon(widget.course),
              size: 64,
              color: Colors.white.withOpacity(0.8),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  begin: Offset(1.0, 1.0),
                  end: Offset(1.1, 1.1),
                  duration: 2000.ms,
                  curve: Curves.easeInOut,
                ),
            SizedBox(height: 8),
            Text(
              widget.course.title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLevelIcon(String level) {
    switch (level) {
      case 'beginner':
        return Icons.trending_up_rounded;
      case 'intermediate':
        return Icons.trending_flat_rounded;
      case 'advanced':
        return Icons.trending_down_rounded;
      default:
        return Icons.circle_rounded;
    }
  }

  String _getLevelText(String level) {
    switch (level) {
      case 'beginner':
        return 'Débutant';
      case 'intermediate':
        return 'Intermédiaire';
      case 'advanced':
        return 'Avancé';
      default:
        return level;
    }
  }

  /// Retourne l'icône appropriée selon la catégorie du cours
  IconData _getCourseIcon(CourseModel course) {
    // Si le cours a des catégories, utiliser la première
    if (course.categories.isNotEmpty) {
      final category = course.categories.first.toLowerCase();
      
      switch (category) {
        case 'développement':
        case 'development':
          return Icons.code_rounded;
        case 'design':
          return Icons.palette_rounded;
        case 'business':
          return Icons.business_center_rounded;
        case 'marketing':
          return Icons.trending_up_rounded;
        case 'langues':
        case 'languages':
          return Icons.language_rounded;
        case 'photographie':
        case 'photography':
          return Icons.camera_alt_rounded;
        case 'musique':
        case 'music':
          return Icons.music_note_rounded;
        case 'santé':
        case 'health':
          return Icons.favorite_rounded;
        case 'sport':
          return Icons.sports_soccer_rounded;
        case 'cuisine':
        case 'cooking':
          return Icons.restaurant_rounded;
        default:
          return Icons.book_rounded;
      }
    }
    
    // Sinon, déterminer par le titre
    final title = course.title.toLowerCase();
    if (title.contains('flutter') || title.contains('dart') || title.contains('python') || 
        title.contains('javascript') || title.contains('code') || title.contains('programmation')) {
      return Icons.code_rounded;
    } else if (title.contains('design') || title.contains('ui') || title.contains('ux')) {
      return Icons.palette_rounded;
    } else if (title.contains('marketing') || title.contains('business')) {
      return Icons.trending_up_rounded;
    } else {
      return Icons.book_rounded;
    }
  }
}
