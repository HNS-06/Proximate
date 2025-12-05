import 'dart:math';

class SkillMatcher {
  static double calculateSkillMatch(
    List<String> userSkills,
    List<String> otherSkills,
  ) {
    if (userSkills.isEmpty || otherSkills.isEmpty) return 0.0;
    
    final commonSkills = userSkills.where((skill) => otherSkills.contains(skill)).toList();
    final totalUniqueSkills = {...userSkills, ...otherSkills}.length;
    
    return (commonSkills.length / totalUniqueSkills) * 100;
  }
  
  static Map<String, dynamic> analyzeTeamCompatibility(
    List<List<String>> teamSkills,
  ) {
    if (teamSkills.length < 2) return {'score': 100, 'analysis': 'Team is complete'};
    
    double totalScore = 0;
    int comparisons = 0;
    final skillCoverage = <String, int>{};
    
    // Calculate pairwise compatibility
    for (int i = 0; i < teamSkills.length; i++) {
      for (int j = i + 1; j < teamSkills.length; j++) {
        final score = calculateSkillMatch(teamSkills[i], teamSkills[j]);
        totalScore += score;
        comparisons++;
      }
      
      // Track skill coverage
      for (final skill in teamSkills[i]) {
        skillCoverage[skill] = (skillCoverage[skill] ?? 0) + 1;
      }
    }
    
    final avgCompatibility = comparisons > 0 ? totalScore / comparisons : 100;
    
    // Analyze skill diversity
    final uniqueSkills = skillCoverage.keys.toList();
    final skillDistribution = skillCoverage.values.toList();
    final distributionScore = _calculateDistributionScore(skillDistribution);
    
    final overallScore = (avgCompatibility * 0.6) + (distributionScore * 0.4);
    
    return {
      'score': overallScore.round(),
      'compatibility': avgCompatibility.round(),
      'diversity': distributionScore.round(),
      'uniqueSkills': uniqueSkills.length,
      'skillGaps': _findSkillGaps(uniqueSkills, teamSkills),
      'recommendations': _generateRecommendations(overallScore, uniqueSkills.length),
    };
  }
  
  static double _calculateDistributionScore(List<int> distribution) {
    if (distribution.isEmpty) return 0.0;
    
    final avg = distribution.reduce((a, b) => a + b) / distribution.length;
    final variance = distribution.map((x) => pow(x - avg, 2)).reduce((a, b) => a + b) / distribution.length;
    final stdDev = sqrt(variance);
    
    // Lower variance = better distribution
    return max(0, 100 - (stdDev * 20));
  }
  
  static List<String> _findSkillGaps(
    List<String> currentSkills,
    List<List<String>> teamSkills,
  ) {
    const commonHackathonSkills = [
      'Frontend', 'Backend', 'UI/UX', 'Mobile', 'AI/ML',
      'DevOps', 'Database', 'Security', 'Blockchain',
    ];
    
    return commonHackathonSkills.where((skill) {
      return !currentSkills.any((s) => s.toLowerCase().contains(skill.toLowerCase()));
    }).toList();
  }
  
  static List<String> _generateRecommendations(double score, int uniqueSkillCount) {
    final recommendations = <String>[];
    
    if (score < 60) {
      recommendations.add('Consider adding members with complementary skills');
      recommendations.add('Team skills overlap too much - diversify');
    }
    
    if (uniqueSkillCount < 4) {
      recommendations.add('Team needs more diverse skill sets');
      recommendations.add('Consider adding backend/frontend specialists');
    }
    
    if (score > 80) {
      recommendations.add('Great team composition!');
      recommendations.add('Well-balanced skill distribution');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Team composition is good');
    }
    
    return recommendations;
  }
  
  static List<String> suggestSkillsToLearn(
    List<String> currentSkills,
    List<String> desiredSkills,
  ) {
    return desiredSkills.where((skill) {
      return !currentSkills.any((s) => s.toLowerCase().contains(skill.toLowerCase()));
    }).toList();
  }
}