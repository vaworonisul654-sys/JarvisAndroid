class LearnerProfile {
  double overallLevel;
  List<String> userContext;
  List<String> learnedVocabulary;
  String lastSessionSummary;
  String currentLessonTopic;
  String teachingFocus;
  int curriculumProgress;

  LearnerProfile({
    this.overallLevel = 1.0,
    this.userContext = const [],
    this.learnedVocabulary = const [],
    this.lastSessionSummary = "",
    this.currentLessonTopic = "Greeting & Basics",
    this.teachingFocus = "Speaking & Fluency",
    this.curriculumProgress = 0,
  });

  Map<String, dynamic> toJson() => {
    'overallLevel': overallLevel,
    'userContext': userContext,
    'learnedVocabulary': learnedVocabulary,
    'lastSessionSummary': lastSessionSummary,
    'currentLessonTopic': currentLessonTopic,
    'teachingFocus': teachingFocus,
    'curriculumProgress': curriculumProgress,
  };
}
