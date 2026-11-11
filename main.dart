// JobBridge - Flutter Android demo (single file)
// Replace lib/main.dart in a newly created Flutter project.
// Uses only Flutter SDK widgets; no pubspec dependencies or backend.
// IMPORTANT: Authentication is a local in-memory demo, NOT production security.

import 'package:flutter/material.dart';

void main() => runApp(const JobBridgeApp());

const Color brand = Color(0xFF4F46E5);
const Color canvas = Color(0xFFF5F7FB);

class Job {
  final int id;
  final String title, company, location, mode, type, salary, description;
  final List<String> skills;
  final bool owned;
  final String ownerEmail;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.mode,
    required this.type,
    required this.salary,
    required this.description,
    required this.skills,
    this.owned = false,
    this.ownerEmail = '',
  });
}

class JobApplication {
  final int jobId;
  final String name, email, accountEmail;
  final int matchAtApply;
  final DateTime appliedAt;
  String status;

  JobApplication({
    required this.jobId,
    required this.name,
    required this.email,
    required this.accountEmail,
    required this.matchAtApply,
    required this.appliedAt,
    this.status = 'Submitted',
  });
}

// Profile submitted by a job seeker during registration.
class CandidateProfile {
  final String phone;
  final String location;
  final String qualification;
  final String course;
  final String graduationYear;
  final String experience;
  final String preferredRole;
  final String preferredMode;
  final String portfolio;
  final String about;

  const CandidateProfile({
    required this.phone,
    required this.location,
    required this.qualification,
    required this.course,
    required this.graduationYear,
    required this.experience,
    required this.preferredRole,
    required this.preferredMode,
    required this.portfolio,
    required this.about,
  });
}

// Shared form state, reused during signup and when editing the profile.
class CandidateProfileDraft {
  // Single-source choice lists used by both signup and profile editing.
  static const degreeOptions = <String>[
    '10th / SSC',
    'Intermediate / 12th',
    'Diploma',
    'B.Tech',
    'B.E.',
    'B.Sc',
    'B.Com',
    'B.A.',
    'BBA',
    'BCA',
    'B.Pharm',
    'MBBS',
    'B.Arch',
    'B.Ed',
    'M.Tech',
    'M.E.',
    'M.Sc',
    'M.Com',
    'M.A.',
    'MBA',
    'MCA',
    'M.Pharm',
    'M.Ed',
    'Ph.D.',
    'Other',
  ];
  static const specializationOptions = <String>[
    'Computer Science',
    'Information Technology',
    'Artificial Intelligence & Data Science',
    'Data Science',
    'Cyber Security',
    'Electronics & Communication',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Business Administration',
    'Finance',
    'Accounting',
    'Commerce',
    'Economics',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Medicine',
    'Pharmacy',
    'Architecture',
    'Education',
    'General / Not applicable',
    'Other',
  ];
  static const jobRoleOptions = <String>[
    'Flutter Developer',
    'Android Developer',
    'iOS Developer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'Java Developer',
    'Python Developer',
    'React Developer',
    'Web Developer',
    'Software Engineer',
    'UI/UX Designer',
    'Data Analyst',
    'Data Scientist',
    'ML Engineer',
    'AI Engineer',
    'DevOps Engineer',
    'Cloud Engineer',
    'Cyber Security Analyst',
    'QA / Test Engineer',
    'Business Analyst',
    'Product Analyst',
    'Database Administrator',
    'Technical Support',
    'Digital Marketing Executive',
    'HR Executive',
    'Other',
  ];
  static const locationOptions = <String>[
    'Hyderabad',
    'Bengaluru',
    'Chennai',
    'Mumbai',
    'New Delhi',
    'Pune',
    'Kolkata',
    'Ahmedabad',
    'Jaipur',
    'Chandigarh',
    'Visakhapatnam',
    'Vijayawada',
    'Warangal',
    'Guntur',
    'Tirupati',
    'Kochi',
    'Thiruvananthapuram',
    'Coimbatore',
    'Madurai',
    'Mysuru',
    'Mangaluru',
    'Nagpur',
    'Indore',
    'Bhopal',
    'Lucknow',
    'Kanpur',
    'Patna',
    'Bhubaneswar',
    'Surat',
    'Vadodara',
    'Nashik',
    'Guwahati',
    'Dehradun',
    'Other',
  ];
  // Recent and upcoming passing years, most recent first.
  // Older/later years can still be entered via Other.
  static List<String> get passingYearOptions => <String>[
        for (var y = DateTime.now().year + 10; y >= 1980; y--) '$y',
        'Other',
      ];
  static const skillOptions = <String>[
    'Flutter',
    'Dart',
    'Java',
    'Kotlin',
    'Swift',
    'Python',
    'C',
    'C++',
    'C#',
    'JavaScript',
    'TypeScript',
    'HTML',
    'CSS',
    'React',
    'Angular',
    'Node.js',
    'Spring Boot',
    'SQL',
    'MySQL',
    'MongoDB',
    'Firebase',
    'REST APIs',
    'Git',
    'GitHub',
    'AWS',
    'Azure',
    'Docker',
    'Linux',
    'Figma',
    'UI Design',
    'Prototyping',
    'Excel',
    'Power BI',
    'Tableau',
    'Pandas',
    'Machine Learning',
    'Deep Learning',
    'Data Analysis',
    'Selenium',
    'Software Testing',
    'Communication',
    'Problem Solving',
    'Project Management',
  ];

  final PortalData data;
  final phone = TextEditingController();
  // Only custom choices are typed; standard values come from dropdowns.
  final otherLocation = TextEditingController();
  final otherPassingYear = TextEditingController();
  final portfolio = TextEditingController();
  final about = TextEditingController();

  // Only "Other" choices need text input.
  final otherDegree = TextEditingController();
  final otherSpecialization = TextEditingController();
  final otherJobRole = TextEditingController();
  final otherSkills = TextEditingController();

  String? selectedLocation;
  String? selectedPassingYear;
  String? selectedDegree;
  String? selectedSpecialization;
  String? selectedJobRole;
  String experience = 'Fresher';
  String preferredMode = 'Any';
  final Set<String> chosenSkills = <String>{};
  bool otherSkillSelected = false;

  CandidateProfileDraft(this.data);

  CandidateProfileDraft.fromExisting(
      this.data, CandidateProfile? profile, Set<String> skillsSet) {
    if (profile != null) {
      phone.text = profile.phone;
      if (data.optionsFor(PortalData.locations).contains(profile.location)) {
        selectedLocation = profile.location;
      } else {
        selectedLocation = 'Other';
        otherLocation.text = profile.location;
      }
      if (data
          .optionsFor(PortalData.passingYears)
          .contains(profile.graduationYear)) {
        selectedPassingYear = profile.graduationYear;
      } else {
        selectedPassingYear = 'Other';
        otherPassingYear.text = profile.graduationYear;
      }
      portfolio.text = profile.portfolio;
      about.text = profile.about;
      experience = profile.experience;
      preferredMode = profile.preferredMode;

      if (data.optionsFor(PortalData.degrees).contains(profile.qualification)) {
        selectedDegree = profile.qualification;
      } else {
        selectedDegree = 'Other';
        otherDegree.text = profile.qualification;
      }
      if (data
          .optionsFor(PortalData.specializations)
          .contains(profile.course)) {
        selectedSpecialization = profile.course;
      } else {
        selectedSpecialization = 'Other';
        otherSpecialization.text = profile.course;
      }
      if (data
          .optionsFor(PortalData.jobRoles)
          .contains(profile.preferredRole)) {
        selectedJobRole = profile.preferredRole;
      } else {
        selectedJobRole = 'Other';
        otherJobRole.text = profile.preferredRole;
      }
    }

    final custom = <String>[];
    for (final skill in skillsSet) {
      // Case-insensitive match so legacy profile skills stay selectable.
      String? known;
      for (final option in data.optionsFor(PortalData.skills)) {
        if (option.toLowerCase() == skill.toLowerCase()) {
          known = option;
          break;
        }
      }
      if (known == null) {
        custom.add(skill);
      } else {
        chosenSkills.add(known);
      }
    }
    if (custom.isNotEmpty) {
      otherSkillSelected = true;
      otherSkills.text = (custom..sort()).join(', ');
    }
  }

  String get currentLocation => selectedLocation == 'Other'
      ? otherLocation.text.trim()
      : (selectedLocation ?? '');
  String get passingYear => selectedPassingYear == 'Other'
      ? otherPassingYear.text.trim()
      : (selectedPassingYear ?? '');
  String get degree => selectedDegree == 'Other'
      ? otherDegree.text.trim()
      : (selectedDegree ?? '');
  String get specialization => selectedSpecialization == 'Other'
      ? otherSpecialization.text.trim()
      : (selectedSpecialization ?? '');
  String get preferredJob => selectedJobRole == 'Other'
      ? otherJobRole.text.trim()
      : (selectedJobRole ?? '');

  List<String> parsedSkills() {
    final result = <String>[];
    final seen = <String>{};
    void add(String value) {
      final skill = value.trim();
      if (skill.isNotEmpty && seen.add(skill.toLowerCase())) result.add(skill);
    }

    for (final skill in data.optionsFor(PortalData.skills)) {
      if (chosenSkills.contains(skill)) add(skill);
    }
    if (otherSkillSelected) {
      for (final part in otherSkills.text.split(',')) {
        add(part);
      }
    }
    return result;
  }

  CandidateProfile toProfile() => CandidateProfile(
        phone: phone.text.trim(),
        location: currentLocation,
        qualification: degree,
        course: specialization,
        graduationYear: passingYear,
        experience: experience,
        preferredRole: preferredJob,
        preferredMode: preferredMode,
        portfolio: portfolio.text.trim(),
        about: about.text.trim(),
      );

  void dispose() {
    for (final c in [
      phone,
      otherLocation,
      otherPassingYear,
      portfolio,
      about,
      otherDegree,
      otherSpecialization,
      otherJobRole,
      otherSkills
    ]) {
      c.dispose();
    }
  }
}

// Individual demo accounts keep saved jobs, skills, and practice separately.
// Passwords are held in memory only; a real deployment must use a secure backend.
class PortalAccount {
  final String email;
  String name;
  String password;
  bool recruiter;
  final bool admin;
  bool enabled;
  final Set<String> skills;
  CandidateProfile? candidateProfile;
  final Set<int> savedIds = <int>{};
  final Map<int, Set<String>> practicedSkills = <int, Set<String>>{};

  PortalAccount({
    required this.email,
    required this.name,
    required this.password,
    required this.recruiter,
    this.admin = false,
    this.enabled = true,
    Set<String>? skills,
    this.candidateProfile,
  }) : skills = skills ?? <String>{};
}

// Shared demo job board, with account-specific access to applications.
class PortalData extends ChangeNotifier {
  static const demoCandidateEmail = 'candidate@jobbridge.demo';
  static const demoRecruiterEmail = 'recruiter@jobbridge.demo';
  static const demoAdminEmail = 'admin@jobbridge.demo';

  // Public users can never create an admin account. Only this seeded demo
  // admin has administrative privileges (not safe for production security).
  static const locations = 'Cities / locations';
  static const passingYears = 'Graduation / passing years';
  static const degrees = 'Degrees / qualifications';
  static const specializations = 'Courses / specializations';
  static const jobRoles = 'Preferred job roles';
  static const skills = 'Skills';
  static const experience = 'Experience';
  static const workModes = 'Work modes';
  static const jobTypes = 'Employment types';
  static const statuses = 'Application statuses';

  static const catalogCategories = <String>[
    locations,
    passingYears,
    degrees,
    specializations,
    jobRoles,
    skills,
    experience,
    workModes,
    jobTypes,
    statuses,
  ];

  final Map<String, List<String>> _catalogs = {
    locations: [...CandidateProfileDraft.locationOptions],
    passingYears: CandidateProfileDraft.passingYearOptions,
    degrees: [...CandidateProfileDraft.degreeOptions],
    specializations: [...CandidateProfileDraft.specializationOptions],
    jobRoles: [...CandidateProfileDraft.jobRoleOptions],
    skills: [...CandidateProfileDraft.skillOptions],
    experience: [
      'Fresher',
      'Less than 1 year',
      '1–3 years',
      '3–5 years',
      '5+ years',
    ],
    workModes: ['Any', 'Remote', 'Hybrid', 'On-site'],
    jobTypes: ['Full-time', 'Part-time', 'Internship', 'Contract'],
    statuses: ['Submitted', 'Under review', 'Shortlisted', 'Rejected'],
  };

  List<String> optionsFor(String category) =>
      List<String>.unmodifiable(_catalogs[category] ?? const <String>[]);

  // Returns null on success and an error message otherwise.
  String? updateOption(String category, String? previous, String value) {
    if (!isAdmin) return 'Only administrators may edit option lists.';
    final options = _catalogs[category];
    if (options == null) return 'Unknown option category.';
    final next = value.trim();
    if (next.isEmpty) return 'Enter a non-empty option.';
    if (next.length > 70) return 'Keep options under 70 characters.';
    // Custom years must also be usable by the job-seeker profile validator.
    if (category == passingYears) {
      final year = int.tryParse(next);
      if (year == null || year < 1950 || year > 2100 || next.length != 4) {
        return 'Enter a four-digit passing year (1950–2100).';
      }
    }
    if (next.toLowerCase() == 'other' ||
        next.toLowerCase() == 'other (add your own)') {
      return 'Other is a reserved option.';
    }
    if (options
        .any((x) => x.toLowerCase() == next.toLowerCase() && x != previous)) {
      return 'This option already exists.';
    }
    if (previous == null) {
      final otherIndex = options.indexOf('Other');
      if (otherIndex >= 0) {
        options.insert(otherIndex, next);
      } else {
        options.add(next);
      }
    } else {
      if (previous == 'Other') return 'The Other option cannot be modified.';
      final index = options.indexOf(previous);
      if (index < 0) return 'The original option no longer exists.';
      options[index] = next;
    }
    notifyListeners();
    return null;
  }

  String? deleteOption(String category, String option) {
    if (!isAdmin) return 'Only administrators may edit option lists.';
    final options = _catalogs[category];
    if (options == null || !options.contains(option))
      return 'Option not found.';
    if (option == 'Other') return 'The Other option is required.';
    if (options.length <= 1 ||
        (options.contains('Other') && options.length <= 2)) {
      return 'Keep at least one selectable option.';
    }
    options.remove(option);
    notifyListeners();
    return null;
  }

  final Map<String, PortalAccount> _accounts = {
    demoCandidateEmail: PortalAccount(
      email: demoCandidateEmail,
      name: 'Demo Candidate',
      password: 'demo123',
      recruiter: false,
      skills: {'Flutter', 'Dart', 'Git', 'UI Design'},
      candidateProfile: const CandidateProfile(
        phone: '9876543210',
        location: 'Hyderabad',
        qualification: 'B.Tech',
        course: 'Information Technology',
        graduationYear: '2026',
        experience: 'Fresher',
        preferredRole: 'Flutter Developer',
        preferredMode: 'Hybrid',
        portfolio: '',
        about: 'Interested in mobile app development.',
      ),
    ),
    demoRecruiterEmail: PortalAccount(
      email: demoRecruiterEmail,
      name: 'Demo Recruiter',
      password: 'demo123',
      recruiter: true,
    ),
    demoAdminEmail: PortalAccount(
      email: demoAdminEmail,
      name: 'Demo Administrator',
      password: 'demo123',
      recruiter: false,
      admin: true,
    ),
  };
  PortalAccount? _current;
  final List<JobApplication> _allApplications = [];
  int _nextId = 100;

  bool get isLoggedIn => _current != null;
  bool get isAdmin => _current?.admin ?? false;
  bool get isRecruiter => !isAdmin && (_current?.recruiter ?? false);
  String get candidateName => _current?.name ?? '';
  String get candidateEmail => _current?.email ?? '';
  Set<String> get mySkills => _current?.skills ?? <String>{};
  CandidateProfile? get myCandidateProfile => _current?.candidateProfile;

  // Recruiters can view profile details of candidates who applied.
  CandidateProfile? appliedCandidateProfile(String email) {
    if (!isRecruiter) return null;
    return _accounts[email.toLowerCase()]?.candidateProfile;
  }

  Set<int> get savedIds => _current?.savedIds ?? <int>{};
  Map<int, Set<String>> get practicedSkills =>
      _current?.practicedSkills ?? <int, Set<String>>{};

  // Null means success; otherwise the string is a user-facing error.
  String? signIn(String email, String password) {
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      return 'Incorrect email or password.';
    }
    if (!account.enabled) return 'Account suspended. Contact an administrator.';
    _current = account;
    notifyListeners();
    return null;
  }

  String? signUp({
    required String name,
    required String email,
    required String password,
    required bool recruiter,
    CandidateProfile? candidateProfile,
    List<String> candidateSkills = const [],
  }) {
    final normalized = email.trim().toLowerCase();
    if (_accounts.containsKey(normalized)) {
      return 'This email is already registered. Please log in.';
    }
    if (!recruiter && (candidateProfile == null || candidateSkills.isEmpty)) {
      return 'Complete your job seeker profile and add at least one skill.';
    }
    final account = PortalAccount(
      email: normalized,
      name: name.trim(),
      password: password,
      recruiter: recruiter,
      candidateProfile: recruiter ? null : candidateProfile,
      skills: recruiter ? <String>{} : candidateSkills.toSet(),
    );
    _accounts[normalized] = account;
    _current = account;
    notifyListeners();
    return null;
  }

  void signOut() {
    _current = null;
    notifyListeners();
  }

  // Administrative account management. Never allow editing the admin role.
  List<PortalAccount> get adminAccounts => isAdmin
      ? (List<PortalAccount>.of(_accounts.values)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())))
      : <PortalAccount>[];

  int get userCount =>
      isAdmin ? _accounts.values.where((a) => !a.admin).length : 0;
  int get seekerCount => isAdmin
      ? _accounts.values.where((a) => !a.admin && !a.recruiter).length
      : 0;
  int get recruiterCount => isAdmin
      ? _accounts.values.where((a) => !a.admin && a.recruiter).length
      : 0;
  int get suspendedCount => isAdmin
      ? _accounts.values.where((a) => !a.admin && !a.enabled).length
      : 0;
  int get applicationCount => isAdmin ? _allApplications.length : 0;

  String? updateUserName(String email, String name) {
    if (!isAdmin) return 'Administrator access required.';
    final user = _accounts[email.toLowerCase()];
    if (user == null || user.admin) return 'You cannot edit this account.';
    if (name.trim().isEmpty) return 'Name cannot be empty.';
    user.name = name.trim();
    notifyListeners();
    return null;
  }

  String? setUserEnabled(String email, bool enabled) {
    if (!isAdmin) return 'Administrator access required.';
    final user = _accounts[email.toLowerCase()];
    if (user == null || user.admin) return 'You cannot change this account.';
    user.enabled = enabled;
    notifyListeners();
    return null;
  }

  String? setUserRecruiter(String email, bool recruiter) {
    if (!isAdmin) return 'Administrator access required.';
    final user = _accounts[email.toLowerCase()];
    if (user == null || user.admin) return 'You cannot change this account.';
    user.recruiter = recruiter;
    notifyListeners();
    return null;
  }

  String? resetUserPassword(String email, String newPassword) {
    if (!isAdmin) return 'Administrator access required.';
    final user = _accounts[email.toLowerCase()];
    if (user == null || user.admin) return 'You cannot change this account.';
    if (newPassword.length < 6)
      return 'Password must be at least 6 characters.';
    user.password = newPassword;
    notifyListeners();
    return null;
  }

  String? deleteUser(String email) {
    if (!isAdmin) return 'Administrator access required.';
    final normalized = email.toLowerCase();
    final user = _accounts[normalized];
    if (user == null || user.admin) return 'You cannot delete this account.';
    final removedJobIds =
        jobs.where((j) => j.ownerEmail == normalized).map((j) => j.id).toSet();
    jobs.removeWhere((j) => removedJobIds.contains(j.id));
    for (final other in _accounts.values) {
      other.savedIds.removeAll(removedJobIds);
      for (final id in removedJobIds) {
        other.practicedSkills.remove(id);
      }
    }
    _allApplications.removeWhere(
        (a) => a.accountEmail == normalized || removedJobIds.contains(a.jobId));
    _accounts.remove(normalized);
    notifyListeners();
    return null;
  }

  String? deleteJob(int jobId) {
    if (!isAdmin) return 'Administrator access required.';
    if (!jobs.any((j) => j.id == jobId)) return 'Job not found.';
    jobs.removeWhere((j) => j.id == jobId);
    _allApplications.removeWhere((a) => a.jobId == jobId);
    for (final user in _accounts.values) {
      user.savedIds.remove(jobId);
      user.practicedSkills.remove(jobId);
    }
    notifyListeners();
    return null;
  }

  // A candidate only sees their own applications. Recruiters use allApplications
  // filtered by their own postings, never another recruiter's postings.
  Map<int, JobApplication> get applications => {
        for (final a in _allApplications)
          if (_current != null && a.accountEmail == _current!.email) a.jobId: a,
      };
  List<JobApplication> get allApplications =>
      List<JobApplication>.unmodifiable(_allApplications);

  final List<Job> jobs = [
    const Job(
      id: 1,
      title: 'Flutter Developer',
      company: 'NovaTech',
      location: 'Hyderabad',
      mode: 'Hybrid',
      type: 'Full-time',
      salary: '₹6–10 LPA',
      owned: true,
      description:
          'Build polished Android applications, integrate REST APIs, and collaborate with product designers.',
      skills: ['Flutter', 'Dart', 'REST APIs', 'Git'],
    ),
    const Job(
      id: 2,
      title: 'Data Analyst',
      company: 'Insight Labs',
      location: 'Bengaluru',
      mode: 'Remote',
      type: 'Full-time',
      salary: '₹5–8 LPA',
      description:
          'Turn business data into dashboards, reports, and practical recommendations.',
      skills: ['SQL', 'Python', 'Excel', 'Power BI'],
    ),
    const Job(
      id: 3,
      title: 'UI/UX Design Intern',
      company: 'PixelMint',
      location: 'Hyderabad',
      mode: 'On-site',
      type: 'Internship',
      salary: '₹18,000/month',
      owned: true,
      description:
          'Design mobile screens, clickable prototypes, and user-friendly journeys.',
      skills: ['Figma', 'UI Design', 'Prototyping'],
    ),
    const Job(
      id: 4,
      title: 'Backend Engineer',
      company: 'LoopStack',
      location: 'Pune',
      mode: 'Remote',
      type: 'Full-time',
      salary: '₹8–14 LPA',
      description:
          'Develop reliable web services and APIs for a growing SaaS product.',
      skills: ['Java', 'Spring Boot', 'SQL', 'Git'],
    ),
    const Job(
      id: 5,
      title: 'Machine Learning Intern',
      company: 'Synapse AI',
      location: 'Chennai',
      mode: 'Hybrid',
      type: 'Internship',
      salary: '₹25,000/month',
      description:
          'Help prepare datasets, train baseline models, and explain experiment results.',
      skills: ['Python', 'Machine Learning', 'Pandas'],
    ),
    const Job(
      id: 6,
      title: 'Mobile App Developer',
      company: 'AppOrbit',
      location: 'Remote',
      mode: 'Remote',
      type: 'Full-time',
      salary: '₹7–12 LPA',
      description:
          'Create cross-platform features and connect mobile apps to cloud services.',
      skills: ['Flutter', 'Dart', 'Firebase', 'Git'],
    ),
    const Job(
      id: 7,
      title: 'QA Automation Engineer',
      company: 'TestWorks',
      location: 'Hyderabad',
      mode: 'On-site',
      type: 'Full-time',
      salary: '₹4–7 LPA',
      description:
          'Write automated test cases and help improve software release quality.',
      skills: ['Java', 'Selenium', 'Git'],
    ),
    const Job(
      id: 8,
      title: 'Product Analyst',
      company: 'Mosaic',
      location: 'Bengaluru',
      mode: 'Hybrid',
      type: 'Full-time',
      salary: '₹7–11 LPA',
      description:
          'Analyze product funnels and help teams make data-informed decisions.',
      skills: ['SQL', 'Excel', 'Product Analytics'],
    ),
  ];

  bool hasSkill(String skill) =>
      mySkills.any((s) => s.toLowerCase() == skill.toLowerCase());

  List<String> missingSkills(Job job) =>
      job.skills.where((s) => !hasSkill(s)).toList();

  int matchPercent(Job job) {
    if (job.skills.isEmpty) return 100;
    final matches = job.skills.where(hasSkill).length;
    return (matches * 100 / job.skills.length).round();
  }

  List<Job> get myPostedJobs => jobs
      .where((job) =>
          isRecruiter &&
          (job.ownerEmail == candidateEmail ||
              (job.owned &&
                  job.ownerEmail.isEmpty &&
                  candidateEmail == demoRecruiterEmail)))
      .toList();

  void toggleSaved(int jobId) {
    if (isRecruiter || isAdmin || !isLoggedIn) return;
    if (!savedIds.add(jobId)) savedIds.remove(jobId);
    notifyListeners();
  }

  void addSkill(String text) {
    if (isRecruiter || isAdmin || !isLoggedIn) return;
    final skill = text.trim();
    if (skill.isNotEmpty && !hasSkill(skill)) {
      mySkills.add(skill);
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    if (isRecruiter || isAdmin || !isLoggedIn) return;
    mySkills.remove(skill);
    notifyListeners();
  }

  void updateCandidateProfile({
    required String name,
    required CandidateProfile profile,
    required List<String> skills,
  }) {
    if (_current == null || isRecruiter || isAdmin) return;
    _current!.name = name.trim();
    _current!.candidateProfile = profile;
    _current!.skills
      ..clear()
      ..addAll(skills);
    notifyListeners();
  }

  void togglePractice(int jobId, String skill) {
    if (isRecruiter || isAdmin || !isLoggedIn) return;
    final done = practicedSkills.putIfAbsent(jobId, () => <String>{});
    if (!done.add(skill)) done.remove(skill);
    notifyListeners();
  }

  bool practiceDone(int jobId, String skill) =>
      practicedSkills[jobId]?.contains(skill) ?? false;

  void apply(Job job, String name, String email) {
    if (isRecruiter ||
        isAdmin ||
        !isLoggedIn ||
        applications.containsKey(job.id)) return;
    _current!.name = name.trim();
    _allApplications.add(JobApplication(
      jobId: job.id,
      name: _current!.name,
      email: _current!.email, // Locked to authenticated identity.
      accountEmail: _current!.email,
      matchAtApply: matchPercent(job),
      appliedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void updateApplicationStatus(JobApplication application, String status) {
    if (!isRecruiter || !myPostedJobs.any((j) => j.id == application.jobId)) {
      return;
    }
    if (!_allApplications.contains(application)) return;
    application.status = status;
    notifyListeners();
  }

  void postJob({
    required String title,
    required String company,
    required String location,
    required String mode,
    required String type,
    required String salary,
    required String description,
    required List<String> skills,
  }) {
    if (!isRecruiter || !isLoggedIn) return;
    jobs.insert(
        0,
        Job(
          id: _nextId++,
          title: title.trim(),
          company: company.trim(),
          location: location.trim(),
          mode: mode,
          type: type,
          salary: salary.trim(),
          description: description.trim(),
          skills: skills,
          owned: true,
          ownerEmail: candidateEmail,
        ));
    notifyListeners();
  }
}

class JobBridgeApp extends StatefulWidget {
  const JobBridgeApp({super.key});
  @override
  State<JobBridgeApp> createState() => _JobBridgeAppState();
}

class _JobBridgeAppState extends State<JobBridgeApp> {
  final PortalData data = PortalData();
  bool _showSignUp = false;

  @override
  void dispose() {
    data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'JobBridge',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: brand),
          scaffoldBackgroundColor: canvas,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF111827),
            elevation: 0,
            centerTitle: false,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        home: AnimatedBuilder(
          animation: data,
          builder: (context, _) {
            if (data.isLoggedIn && data.isAdmin) {
              return AdminHome(key: ValueKey(data.candidateEmail), data: data);
            }
            if (data.isLoggedIn) {
              return PortalHome(
                key: ValueKey(data.candidateEmail),
                data: data,
              );
            }
            // Authentication screens are both on the root route. Switching
            // them here avoids popping a route whose home was just replaced.
            if (_showSignUp) {
              return SignUpPage(
                key: const ValueKey('signup'),
                data: data,
                onBackToLogin: () => setState(() => _showSignUp = false),
                onSignedUp: () => setState(() => _showSignUp = false),
              );
            }
            return LoginPage(
              key: const ValueKey('login'),
              data: data,
              onCreateAccount: () => setState(() => _showSignUp = true),
            );
          },
        ),
      );
}

// -----------------------------------------------------------------------------
// Login and registration screens (Flutter-only, in-memory demonstration).
// -----------------------------------------------------------------------------
class LoginPage extends StatefulWidget {
  final PortalData data;
  final VoidCallback onCreateAccount;
  const LoginPage({
    super.key,
    required this.data,
    required this.onCreateAccount,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showRegistration() {
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onCreateAccount();
    });
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text;
    final password = _password.text;
    // Dismiss the focused field before changing the entire auth screen.
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final result = widget.data.signIn(email, password);
      if (result != null && mounted) setState(() => _error = result);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              children: [
                const Center(
                    child: CircleAvatar(
                  radius: 37,
                  backgroundColor: Color(0xFFEDE9FE),
                  child: Icon(Icons.hub_rounded, color: brand, size: 41),
                )),
                const SizedBox(height: 18),
                const Text('Welcome to JobBridge',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text('Sign in to find opportunities or hire talent',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 30),
                Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.email_outlined)),
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _password,
                        obscureText: _hidden,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _login(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip:
                                _hidden ? 'Show password' : 'Hide password',
                            icon: Icon(_hidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _hidden = !_hidden),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Enter your password'
                            : null,
                      ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(_error!,
                              style: const TextStyle(color: Colors.red)),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _login,
                            child: const Padding(
                                padding: EdgeInsets.all(13),
                                child: Text('Log in')),
                          )),
                    ])),
                const SizedBox(height: 18),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('New to JobBridge?'),
                  TextButton(
                    onPressed: _showRegistration,
                    child: const Text('Create account'),
                  ),
                ]),
                const SizedBox(height: 20),
                Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Try demo accounts',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 7),
                            const Text('Password for all three: demo123',
                                style: TextStyle(color: Colors.black54)),
                            Wrap(spacing: 8, runSpacing: 4, children: [
                              TextButton.icon(
                                onPressed: () => setState(() {
                                  _email.text = PortalData.demoCandidateEmail;
                                  _password.text = 'demo123';
                                  _error = null;
                                }),
                                icon: const Icon(Icons.person_outline),
                                label: const Text('Fill candidate demo'),
                              ),
                              TextButton.icon(
                                onPressed: () => setState(() {
                                  _email.text = PortalData.demoRecruiterEmail;
                                  _password.text = 'demo123';
                                  _error = null;
                                }),
                                icon:
                                    const Icon(Icons.business_center_outlined),
                                label: const Text('Fill recruiter demo'),
                              ),
                              TextButton.icon(
                                onPressed: () => setState(() {
                                  _email.text = PortalData.demoAdminEmail;
                                  _password.text = 'demo123';
                                  _error = null;
                                }),
                                icon: const Icon(
                                    Icons.admin_panel_settings_outlined),
                                label: const Text('Fill admin demo'),
                              ),
                            ]),
                          ]),
                    )),
                const SizedBox(height: 12),
                const Text(
                    'Demo only: accounts are stored in memory and reset '
                    'when you restart the app. Do not use a real password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 12)),
              ]),
        ))),
      );
}

class SignUpPage extends StatefulWidget {
  final PortalData data;
  final VoidCallback onBackToLogin;
  final VoidCallback onSignedUp;
  const SignUpPage({
    super.key,
    required this.data,
    required this.onBackToLogin,
    required this.onSignedUp,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _accountFormKey = GlobalKey<FormState>();
  final _profileFormKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  late final _profile = CandidateProfileDraft(widget.data);
  bool _isRecruiter = false;
  bool _profileStep = false;
  bool _hidden = true;
  String? _error;

  @override
  void dispose() {
    for (final controller in [_name, _email, _password, _confirm]) {
      controller.dispose();
    }
    _profile.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_accountFormKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_isRecruiter) {
      setState(() => _error = null);
      _register();
    } else {
      // Switching between two Forms while a TextField has focus can leave
      // stale inherited-widget dependents on some Flutter versions.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _error = null;
          _profileStep = true;
        });
      });
    }
  }

  void _register() {
    if (!_isRecruiter && !_profileFormKey.currentState!.validate()) return;
    final name = _name.text;
    final email = _email.text;
    final password = _password.text;
    final recruiter = _isRecruiter;
    final profile = recruiter ? null : _profile.toProfile();
    final skills = recruiter ? <String>[] : _profile.parsedSkills();
    // Completing signup replaces a Form-heavy screen. Finish the current
    // interaction (including keyboard/focus changes) before replacing it.
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final result = widget.data.signUp(
        name: name,
        email: email,
        password: password,
        recruiter: recruiter,
        candidateProfile: profile,
        candidateSkills: skills,
      );
      if (result != null) {
        if (mounted) setState(() => _error = result);
        return;
      }
      widget.onSignedUp();
    });
  }

  void _back() {
    final wasProfileStep = _profileStep;
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (wasProfileStep) {
        setState(() {
          _profileStep = false;
          _error = null;
        });
      } else {
        widget.onBackToLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: _profileStep ? 'Back to account details' : 'Back to login',
            onPressed: _back,
          ),
          title: Text(_profileStep ? 'Job seeker profile' : 'Create account'),
        ),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 36),
            children: [
              Row(children: [
                Expanded(
                    child: LinearProgressIndicator(
                  value: (_profileStep || _isRecruiter) ? 1 : 0.5,
                  minHeight: 7,
                )),
                const SizedBox(width: 12),
                Text(
                    _isRecruiter
                        ? 'Recruiter signup'
                        : (_profileStep ? 'Step 2 of 2' : 'Step 1 of 2'),
                    style: const TextStyle(color: Colors.black54)),
              ]),
              const SizedBox(height: 22),
              if (!_profileStep) ...[
                const Text('Welcome to JobBridge',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                const Text(
                    'Create your account. Job seekers will build a profile next.',
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 22),
                Row(children: [
                  Expanded(
                      child: ChoiceChip(
                    label: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline, size: 17),
                          SizedBox(width: 6),
                          Text('Job seeker')
                        ]),
                    selected: !_isRecruiter,
                    onSelected: (_) => setState(() => _isRecruiter = false),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: ChoiceChip(
                    label: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business_center_outlined, size: 17),
                          SizedBox(width: 6),
                          Text('Recruiter')
                        ]),
                    selected: _isRecruiter,
                    onSelected: (_) => setState(() => _isRecruiter = true),
                  )),
                ]),
                const SizedBox(height: 22),
                Form(
                    key: _accountFormKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: _isRecruiter
                                ? 'Recruiter full name *'
                                : 'Full name *',
                            prefixIcon: const Icon(Icons.person_outline)),
                        validator: requiredText,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            labelText: 'Email address *',
                            prefixIcon: Icon(Icons.email_outlined)),
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _password,
                        obscureText: _hidden,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Password (min 6 characters) *',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip:
                                _hidden ? 'Show passwords' : 'Hide passwords',
                            icon: Icon(_hidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _hidden = !_hidden),
                          ),
                        ),
                        validator: (v) => (v?.length ?? 0) < 6
                            ? 'Use at least 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _confirm,
                        obscureText: _hidden,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _continue(),
                        decoration: const InputDecoration(
                            labelText: 'Confirm password *',
                            prefixIcon: Icon(Icons.lock_reset_outlined)),
                        validator: (v) => v != _password.text
                            ? 'Passwords do not match'
                            : null,
                      ),
                    ])),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _continue,
                      icon: Icon(_isRecruiter
                          ? Icons.person_add_alt_1
                          : Icons.arrow_forward),
                      label: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Text(_isRecruiter
                            ? 'Create recruiter account'
                            : 'Continue to profile'),
                      ),
                    )),
                const SizedBox(height: 13),
                Center(
                    child: TextButton(
                  onPressed: _back,
                  child: const Text('Already registered? Log in'),
                )),
              ] else ...[
                const Text('Tell employers about yourself',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text(
                    'Hi ${_name.text.trim()}! Complete your profile to get '
                    'skill-based job matches.',
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 18),
                Form(
                  key: _profileFormKey,
                  child: CandidateProfileFields(draft: _profile),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _register,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Padding(
                        padding: EdgeInsets.all(13),
                        child: Text('Complete signup & view jobs'),
                      ),
                    )),
                const SizedBox(height: 9),
                Center(
                    child: TextButton(
                  onPressed: _back,
                  child: const Text('Back to account details'),
                )),
              ],
              const SizedBox(height: 20),
              const Text(
                  'Offline demo: account details are stored in app memory '
                  'and reset after restart. Do not use a real password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ))),
      );
}

// Fields are shared between the signup wizard and Profile > Edit profile.
// All components use the Flutter SDK only.
class CandidateProfileFields extends StatefulWidget {
  final CandidateProfileDraft draft;
  const CandidateProfileFields({super.key, required this.draft});

  @override
  State<CandidateProfileFields> createState() => _CandidateProfileFieldsState();
}

class _CandidateProfileFieldsState extends State<CandidateProfileFields> {
  // Searchable multi-select picker keeps a large skills catalogue usable
  // on a phone. It updates the shared profile draft without extra packages.
  Future<void> _chooseSkills(FormFieldState<bool> fieldState) async {
    final draft = widget.draft;
    var search = '';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, updateSheet) {
          final options = <String>[
            ...draft.data.optionsFor(PortalData.skills).where(
                  (s) => s.toLowerCase().contains(search.toLowerCase()),
                ),
            // Always offer custom entry, even for a search with no matches.
            'Other (add your own)',
          ];
          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: SizedBox(
                height: MediaQuery.of(sheetContext).size.height * 0.75,
                child: Column(children: [
                  const SizedBox(height: 12),
                  Container(
                    height: 4,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Select your skills',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    child: Text(
                        'Select multiple skills, or choose Other for a custom skill.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: TextField(
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: 'Search for a skill',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (v) => updateSheet(() => search = v),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: options.length,
                    itemBuilder: (context, i) {
                      final skill = options[i];
                      final isOther = skill == 'Other (add your own)';
                      final selected = isOther
                          ? draft.otherSkillSelected
                          : draft.chosenSkills.contains(skill);
                      return CheckboxListTile(
                        dense: true,
                        title: Text(skill),
                        value: selected,
                        onChanged: (value) => updateSheet(() {
                          if (isOther) {
                            draft.otherSkillSelected = value ?? false;
                          } else if (value == true) {
                            draft.chosenSkills.add(skill);
                          } else {
                            draft.chosenSkills.remove(skill);
                          }
                        }),
                      );
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: const Text('Done'),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
    if (!mounted || !fieldState.mounted) return;
    setState(() {});
    fieldState.didChange(true);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.draft;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('PERSONAL DETAILS',
          style: TextStyle(
              color: brand, fontSize: 12, fontWeight: FontWeight.bold)),
      const SizedBox(height: 11),
      TextFormField(
        controller: d.phone,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
            labelText: 'Phone number *',
            prefixIcon: Icon(Icons.phone_outlined)),
        validator: (v) {
          final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
          return digits.length < 7 || digits.length > 15
              ? 'Enter a valid phone number (7–15 digits)'
              : null;
        },
      ),
      const SizedBox(height: 13),
      DropdownButtonFormField<String>(
        key: const ValueKey('candidate-location'),
        value: d.selectedLocation,
        isExpanded: true,
        decoration: const InputDecoration(
            labelText: 'Current city / location *',
            prefixIcon: Icon(Icons.location_on_outlined)),
        items: d.data
            .optionsFor(PortalData.locations)
            .map((city) => DropdownMenuItem(
                value: city,
                child: Text(city, overflow: TextOverflow.ellipsis)))
            .toList(),
        validator: (value) =>
            value == null ? 'Select your current location' : null,
        onChanged: (value) => setState(() => d.selectedLocation = value),
      ),
      if (d.selectedLocation == 'Other') ...[
        const SizedBox(height: 13),
        TextFormField(
          key: const ValueKey('candidate-other-location-text'),
          controller: d.otherLocation,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: 'Enter your city / location *',
              hintText: 'e.g. Karimnagar',
              prefixIcon: Icon(Icons.edit_outlined)),
          validator: requiredText,
        ),
      ],
      const SizedBox(height: 23),
      const Text('EDUCATION & EXPERIENCE',
          style: TextStyle(
              color: brand, fontSize: 12, fontWeight: FontWeight.bold)),
      const SizedBox(height: 11),
      DropdownButtonFormField<String>(
        key: const ValueKey('candidate-degree'),
        value: d.selectedDegree,
        isExpanded: true,
        validator: (v) => v == null ? 'Select a degree or qualification' : null,
        decoration: const InputDecoration(
            labelText: 'Degree / qualification *',
            prefixIcon: Icon(Icons.school_outlined)),
        items: d.data
            .optionsFor(PortalData.degrees)
            .map(
              (value) => DropdownMenuItem(value: value, child: Text(value)),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) setState(() => d.selectedDegree = value);
        },
      ),
      if (d.selectedDegree == 'Other') ...[
        const SizedBox(height: 13),
        TextFormField(
          key: const ValueKey('candidate-other-degree-text'),
          controller: d.otherDegree,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Enter your degree / qualification *',
              hintText: 'e.g. B.Des',
              prefixIcon: Icon(Icons.edit_outlined)),
          validator: requiredText,
        ),
      ],
      const SizedBox(height: 13),
      DropdownButtonFormField<String>(
        key: const ValueKey('candidate-specialization'),
        value: d.selectedSpecialization,
        isExpanded: true,
        validator: (v) =>
            v == null ? 'Select a course or specialization' : null,
        decoration: const InputDecoration(
            labelText: 'Course / specialization *',
            prefixIcon: Icon(Icons.menu_book_outlined)),
        items: d.data
            .optionsFor(PortalData.specializations)
            .map(
              (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value, overflow: TextOverflow.ellipsis)),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) setState(() => d.selectedSpecialization = value);
        },
      ),
      if (d.selectedSpecialization == 'Other') ...[
        const SizedBox(height: 13),
        TextFormField(
          key: const ValueKey('candidate-other-specialization-text'),
          controller: d.otherSpecialization,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Enter your course / specialization *',
              hintText: 'e.g. Hotel Management',
              prefixIcon: Icon(Icons.edit_outlined)),
          validator: requiredText,
        ),
      ],
      const SizedBox(height: 13),
      DropdownButtonFormField<String>(
        key: const ValueKey('candidate-passing-year'),
        value: d.selectedPassingYear,
        isExpanded: true,
        decoration: const InputDecoration(
            labelText: 'Graduation / passing year *',
            prefixIcon: Icon(Icons.calendar_today_outlined)),
        items: d.data
            .optionsFor(PortalData.passingYears)
            .map((year) => DropdownMenuItem(value: year, child: Text(year)))
            .toList(),
        validator: (value) => value == null ? 'Select your passing year' : null,
        onChanged: (value) => setState(() => d.selectedPassingYear = value),
      ),
      if (d.selectedPassingYear == 'Other') ...[
        const SizedBox(height: 13),
        TextFormField(
          key: const ValueKey('candidate-other-passing-year-text'),
          controller: d.otherPassingYear,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: 'Enter your passing year *',
              hintText: 'e.g. 1978',
              prefixIcon: Icon(Icons.edit_outlined)),
          validator: (value) {
            final text = (value ?? '').trim();
            final year = int.tryParse(text);
            if (text.length != 4 ||
                year == null ||
                year < 1950 ||
                year > 2100) {
              return 'Enter a four-digit year (1950–2100)';
            }
            return null;
          },
        ),
      ],
      const SizedBox(height: 13),
      DropdownButtonFormField<String>(
        key: const ValueKey('candidate-experience'),
        value: d.experience,
        isExpanded: true,
        decoration: const InputDecoration(
            labelText: 'Work experience *',
            prefixIcon: Icon(Icons.work_history_outlined)),
        items: <String>{
          ...d.data.optionsFor(PortalData.experience),
          d.experience
        }
            .map((value) => DropdownMenuItem(value: value, child: Text(value)))
            .toList(),
        onChanged: (value) {
          if (value != null) setState(() => d.experience = value);
        },
      ),
      const SizedBox(height: 23),
      const Text('SKILLS & JOB PREFERENCES',
          style: TextStyle(
              color: brand, fontSize: 12, fontWeight: FontWeight.bold)),
      const SizedBox(height: 11),
      FormField<bool>(
        key: const ValueKey('candidate-skill-selection'),
        validator: (_) {
          if (d.otherSkillSelected && d.otherSkills.text.trim().isEmpty) {
            return 'Enter the custom skill or deselect Other.';
          }
          return d.parsedSkills().isEmpty ? 'Select at least one skill.' : null;
        },
        builder: (state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _chooseSkills(state),
                  icon: const Icon(Icons.checklist_outlined),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                        'Choose skills (${d.parsedSkills().length} selected)'),
                  ),
                )),
            if (d.chosenSkills.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 0, children: [
                for (final skill in (d.chosenSkills.toList()..sort()))
                  if (d.chosenSkills.contains(skill))
                    InputChip(
                      label: Text(skill),
                      onDeleted: () {
                        setState(() => d.chosenSkills.remove(skill));
                        state.didChange(true);
                      },
                    ),
              ]),
            ],
            if (d.otherSkillSelected) ...[
              const SizedBox(height: 10),
              TextFormField(
                controller: d.otherSkills,
                maxLines: 2,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Other skills *',
                    hintText: 'e.g. Rust, GraphQL, Product Design',
                    helperText: 'Separate multiple custom skills with commas',
                    prefixIcon: Icon(Icons.edit_outlined)),
                validator: requiredText,
                onChanged: (_) => state.didChange(true),
              ),
            ],
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 10),
                child: Text(state.errorText!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12)),
              ),
          ],
        ),
      ),
      const SizedBox(height: 13),
      DropdownButtonFormField<String>(
        key: const ValueKey('candidate-job-role'),
        value: d.selectedJobRole,
        isExpanded: true,
        validator: (v) => v == null ? 'Select a preferred job role' : null,
        decoration: const InputDecoration(
            labelText: 'Preferred job role *',
            prefixIcon: Icon(Icons.badge_outlined)),
        items: d.data
            .optionsFor(PortalData.jobRoles)
            .map(
              (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value, overflow: TextOverflow.ellipsis)),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) setState(() => d.selectedJobRole = value);
        },
      ),
      if (d.selectedJobRole == 'Other') ...[
        const SizedBox(height: 13),
        TextFormField(
          key: const ValueKey('candidate-other-job-role-text'),
          controller: d.otherJobRole,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
              labelText: 'Enter your preferred job role *',
              hintText: 'e.g. Game Developer',
              prefixIcon: Icon(Icons.edit_outlined)),
          validator: requiredText,
        ),
      ],
      const SizedBox(height: 13),
      DropdownButtonFormField<String>(
        key: const ValueKey('candidate-work-mode'),
        value: d.preferredMode,
        isExpanded: true,
        decoration: const InputDecoration(
            labelText: 'Preferred work mode *',
            prefixIcon: Icon(Icons.laptop_outlined)),
        items: <String>{
          ...d.data.optionsFor(PortalData.workModes),
          d.preferredMode
        }.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        onChanged: (value) {
          if (value != null) setState(() => d.preferredMode = value);
        },
      ),
      const SizedBox(height: 23),
      const Text('OPTIONAL DETAILS',
          style: TextStyle(
              color: brand, fontSize: 12, fontWeight: FontWeight.bold)),
      const SizedBox(height: 11),
      TextFormField(
        controller: d.portfolio,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
            labelText: 'Portfolio / LinkedIn / GitHub URL',
            prefixIcon: Icon(Icons.link_outlined)),
        validator: (v) {
          final value = (v ?? '').trim();
          if (value.isEmpty) return null;
          final uri = Uri.tryParse(value);
          if (uri == null ||
              !['https', 'http'].contains(uri.scheme) ||
              uri.host.isEmpty) {
            return 'Enter a valid URL starting with https://';
          }
          return null;
        },
      ),
      const SizedBox(height: 13),
      TextFormField(
        controller: d.about,
        maxLines: 3,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
            labelText: 'About you / career objective',
            hintText: 'A short introduction for recruiters',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.description_outlined)),
      ),
      const SizedBox(height: 6),
      const Text('* Required fields. Selected skills personalize job matches.',
          style: TextStyle(fontSize: 12, color: Colors.black54)),
    ]);
  }
}

class EditCandidateProfilePage extends StatefulWidget {
  final PortalData data;
  const EditCandidateProfilePage({super.key, required this.data});

  @override
  State<EditCandidateProfilePage> createState() =>
      _EditCandidateProfilePageState();
}

class _EditCandidateProfilePageState extends State<EditCandidateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final CandidateProfileDraft _profile;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.data.candidateName);
    _profile = CandidateProfileDraft.fromExisting(
      widget.data,
      widget.data.myCandidateProfile,
      widget.data.mySkills,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _profile.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final data = widget.data;
    final name = _name.text;
    final profile = _profile.toProfile();
    final skills = _profile.parsedSkills();
    final messenger = ScaffoldMessenger.of(context);
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data.updateCandidateProfile(name: name, profile: profile, skills: skills);
      messenger.showSnackBar(const SnackBar(
        content: Text('Profile updated. Job matches refreshed.'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Edit job seeker profile')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        labelText: 'Full name *',
                        prefixIcon: Icon(Icons.person_outline)),
                    validator: requiredText,
                  ),
                  const SizedBox(height: 17),
                  CandidateProfileFields(draft: _profile),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Save profile'),
                    ),
                  ),
                ],
              )),
        ))),
      );
}

// -----------------------------------------------------------------------------
// Administrator dashboard: management actions operate on in-memory demo data.
// Never put privileged production business logic or admin credentials in an APK.
// -----------------------------------------------------------------------------
class AdminHome extends StatefulWidget {
  final PortalData data;
  const AdminHome({super.key, required this.data});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int tab = 0;
  String category = PortalData.degrees;
  String userSearch = '';

  void message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> confirm(String title, String detail) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(detail),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> editOption({String? oldValue}) async {
    final activeCategory = category;
    String candidate = oldValue ?? '';
    String? error;
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, redraw) => AlertDialog(
          title:
              Text(oldValue == null ? 'Add $activeCategory' : 'Rename option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: candidate,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                maxLength: 70,
                onChanged: (value) => candidate = value,
                decoration: InputDecoration(
                  labelText: 'Option name',
                  errorText: error,
                ),
              ),
              const Text(
                  'Existing profile values are preserved when an '
                  'option is renamed or removed.',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = candidate.trim();
                String? issue;
                final options = widget.data.optionsFor(activeCategory);
                if (value.isEmpty) {
                  issue = 'Enter an option.';
                } else if (value.length > 70) {
                  issue = 'Keep options under 70 characters.';
                } else if (value.toLowerCase() == 'other' ||
                    value.toLowerCase() == 'other (add your own)') {
                  issue = 'Other is a reserved option.';
                } else if (options.any((x) =>
                    x.toLowerCase() == value.toLowerCase() && x != oldValue)) {
                  issue = 'That option already exists.';
                } else if (activeCategory == PortalData.passingYears &&
                    (value.length != 4 ||
                        int.tryParse(value) == null ||
                        int.parse(value) < 1950 ||
                        int.parse(value) > 2100)) {
                  issue = 'Enter a passing year between 1950 and 2100.';
                }
                if (issue != null) {
                  redraw(() => error = issue);
                } else {
                  Navigator.pop(ctx, value);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || result == null) return;
    // Update the shared data after the dialog has left its editing state.
    final issue = widget.data.updateOption(activeCategory, oldValue, result);
    message(issue ?? (oldValue == null ? 'Option added.' : 'Option renamed.'));
  }

  Future<void> removeOption(String option) async {
    if (!await confirm(
        'Remove "$option"?',
        'This choice will stop appearing in new selections. '
            'Previously saved profile values will not be erased.')) return;
    final error = widget.data.deleteOption(category, option);
    message(error ?? 'Option removed.');
  }

  Future<void> editUserText(PortalAccount user,
      {required bool password}) async {
    String textValue = password ? '' : user.name;
    String? error;
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, redraw) => AlertDialog(
          title: Text(password ? 'Set a new password' : 'Edit user name'),
          content: TextFormField(
            initialValue: textValue,
            autofocus: true,
            obscureText: password,
            onChanged: (value) => textValue = value,
            decoration: InputDecoration(
              labelText:
                  password ? 'New password (6+ characters)' : 'Full name',
              errorText: error,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final issue = password
                    ? (textValue.length < 6
                        ? 'Password must be at least 6 characters.'
                        : null)
                    : (textValue.trim().isEmpty
                        ? 'Name cannot be empty.'
                        : null);
                if (issue != null) {
                  redraw(() => error = issue);
                } else {
                  Navigator.pop(ctx, textValue);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || result == null) return;
    final issue = password
        ? widget.data.resetUserPassword(user.email, result)
        : widget.data.updateUserName(user.email, result);
    message(issue ??
        (password ? 'Password changed for this demo user.' : 'Name updated.'));
  }

  Future<void> userAction(PortalAccount user, String action) async {
    if (user.admin) return;
    if (action == 'rename') {
      await editUserText(user, password: false);
    } else if (action == 'password') {
      await editUserText(user, password: true);
    } else if (action == 'enabled') {
      final next = !user.enabled;
      if (!await confirm(
          next ? 'Activate account?' : 'Suspend account?',
          '${user.name} (${user.email}) will '
          '${next ? 'be able' : 'not be able'} to log in.')) return;
      message(widget.data.setUserEnabled(user.email, next) ??
          (next ? 'Account activated.' : 'Account suspended.'));
    } else if (action == 'role') {
      final next = !user.recruiter;
      if (!await confirm(
          'Change user role?',
          'Change ${user.email} to ${next ? 'Recruiter' : 'Job Seeker'}? '
              'Existing job postings and applications will remain.')) return;
      message(
          widget.data.setUserRecruiter(user.email, next) ?? 'Role updated.');
    } else if (action == 'delete') {
      if (!await confirm(
          'Delete this user?',
          'This permanently removes ${user.name} from the demo. '
              'Their applications and any jobs they posted will also be removed.'))
        return;
      message(widget.data.deleteUser(user.email) ?? 'User deleted.');
    }
  }

  Widget metric(String value, String label, IconData icon) => Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: brand),
            const SizedBox(height: 11),
            Text(value,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(color: Colors.black54)),
          ]),
        ),
      );

  Widget overview() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Administration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text(
              'Manage users, job listings, and the selection options '
              'used throughout JobBridge.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 15),
          LayoutBuilder(
              builder: (context, constraints) => GridView.count(
                    crossAxisCount: constraints.maxWidth > 470 ? 3 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.15,
                    children: [
                      metric('${widget.data.userCount}', 'Users',
                          Icons.people_outline),
                      metric('${widget.data.seekerCount}', 'Job seekers',
                          Icons.school_outlined),
                      metric('${widget.data.recruiterCount}', 'Recruiters',
                          Icons.business_outlined),
                      metric('${widget.data.jobs.length}', 'Open jobs',
                          Icons.work_outline),
                      metric('${widget.data.applicationCount}', 'Applications',
                          Icons.description_outlined),
                      metric('${widget.data.suspendedCount}', 'Suspended',
                          Icons.block_outlined),
                    ],
                  )),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick actions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.manage_accounts, color: brand),
                      title: const Text('Manage users'),
                      subtitle:
                          const Text('Edit, suspend, change roles, or delete'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => setState(() => tab = 1),
                    ),
                    ListTile(
                      leading: const Icon(Icons.tune, color: brand),
                      title: const Text('Edit profile choices'),
                      subtitle: const Text(
                          'Degrees, roles, skills, and other dropdowns'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => setState(() => tab = 2),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.work_off_outlined, color: brand),
                      title: const Text('Moderate jobs'),
                      subtitle:
                          const Text('Remove inappropriate demo postings'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => setState(() => tab = 3),
                    ),
                  ]),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
              'DEMO ONLY: Administrative permissions and credentials '
              'are local to this application. Data resets when the app restarts. '
              'A real job portal requires server-side authorization, secure '
              'authentication and persistent storage.',
              style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      );

  Widget users() {
    final found = widget.data.adminAccounts
        .where((u) =>
            '${u.name} ${u.email} ${u.admin ? 'admin' : u.recruiter ? 'recruiter' : 'job seeker'}'
                .toLowerCase()
                .contains(userSearch.toLowerCase()))
        .toList();
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('All users',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 9),
          TextField(
            decoration: const InputDecoration(
                hintText: 'Search by name, email or role',
                prefixIcon: Icon(Icons.search)),
            onChanged: (value) => setState(() => userSearch = value),
          ),
          const SizedBox(height: 8),
          Text('${found.length} accounts',
              style: const TextStyle(color: Colors.black54)),
        ]),
      ),
      Expanded(
          child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        itemCount: found.length,
        itemBuilder: (context, index) {
          final user = found[index];
          final role = user.admin
              ? 'Admin'
              : user.recruiter
                  ? 'Recruiter'
                  : 'Job seeker';
          return Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFEDE9FE),
                        child: Icon(
                            user.admin
                                ? Icons.admin_panel_settings
                                : user.recruiter
                                    ? Icons.business
                                    : Icons.person,
                            color: brand),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(user.email,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12)),
                        ],
                      )),
                      if (!user.admin)
                        PopupMenuButton<String>(
                          tooltip: 'Manage ${user.name}',
                          onSelected: (value) => userAction(user, value),
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                                value: 'rename', child: Text('Edit name')),
                            const PopupMenuItem(
                                value: 'password',
                                child: Text('Reset password')),
                            PopupMenuItem(
                                value: 'role',
                                child: Text(user.recruiter
                                    ? 'Make job seeker'
                                    : 'Make recruiter')),
                            PopupMenuItem(
                                value: 'enabled',
                                child: Text(user.enabled
                                    ? 'Suspend account'
                                    : 'Activate account')),
                            const PopupMenuDivider(),
                            const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete user',
                                    style: TextStyle(color: Colors.red))),
                          ],
                        )
                      else
                        const Icon(Icons.lock_outline, color: Colors.black38),
                    ]),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 6, children: [
                      Chip(
                          label: Text(role),
                          visualDensity: VisualDensity.compact),
                      Chip(
                          label: Text(user.enabled ? 'Active' : 'Suspended'),
                          visualDensity: VisualDensity.compact),
                      if (!user.recruiter && !user.admin)
                        Chip(
                            label: Text('${user.skills.length} skills'),
                            visualDensity: VisualDensity.compact),
                    ]),
                    if (user.candidateProfile != null &&
                        !user.recruiter &&
                        !user.admin)
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: const Text('Candidate profile',
                            style: TextStyle(fontSize: 14)),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Location: ${user.candidateProfile!.location}\n'
                              'Degree: ${user.candidateProfile!.qualification}\n'
                              'Specialization: ${user.candidateProfile!.course}\n'
                              'Preferred role: ${user.candidateProfile!.preferredRole}\n'
                              'Skills: ${user.skills.join(', ')}',
                              style: const TextStyle(height: 1.55),
                            ),
                          ),
                        ],
                      ),
                  ]),
            ),
          );
        },
      )),
    ]);
  }

  Widget catalogs() {
    final options = widget.data.optionsFor(category);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Manage selection options',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          const Text(
              'These lists power job-seeker profile forms, recruiter '
              'job posting and applicant-status dropdowns.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: category,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Option category'),
            items: PortalData.catalogCategories
                .map((c) => DropdownMenuItem(
                    value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (next) => setState(() => category = next ?? category),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Text('${options.length} options',
                style: const TextStyle(color: Colors.black54)),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => editOption(),
              icon: const Icon(Icons.add),
              label: const Text('Add option'),
            ),
          ]),
        ]),
      ),
      Expanded(
          child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final reserved = option == 'Other';
          return Card(
            elevation: 0,
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.list_alt_outlined, color: brand),
              title: Text(option),
              subtitle:
                  reserved ? const Text('Required custom-entry option') : null,
              trailing: reserved
                  ? const Icon(Icons.lock_outline, color: Colors.black38)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Rename option',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => editOption(oldValue: option),
                        ),
                        IconButton(
                          tooltip: 'Delete option',
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => removeOption(option),
                        ),
                      ],
                    ),
            ),
          );
        },
      )),
    ]);
  }

  Widget jobs() => Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Manage job postings',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        ),
        Expanded(
            child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
          itemCount: widget.data.jobs.length,
          itemBuilder: (context, index) {
            final job = widget.data.jobs[index];
            return Card(
              color: Colors.white,
              elevation: 0,
              child: ListTile(
                title: Text(job.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '${job.company} · ${job.location}\n${job.type} · ${job.mode}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Remove posting',
                  onPressed: () async {
                    if (!await confirm(
                        'Remove job posting?',
                        'Remove ${job.title} from ${job.company}? '
                            'Associated applications will also be removed.'))
                      return;
                    message(widget.data.deleteJob(job.id) ?? 'Job removed.');
                  },
                ),
              ),
            );
          },
        )),
      ]);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.data,
        builder: (context, child) => Scaffold(
          appBar: AppBar(
            title: const Row(children: [
              Icon(Icons.admin_panel_settings_outlined, color: brand),
              SizedBox(width: 9),
              Text('JobBridge Admin',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
            actions: [
              IconButton(
                tooltip: 'Log out',
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) widget.data.signOut();
                  });
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: SafeArea(child: [overview, users, catalogs, jobs][tab]()),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            selectedIndex: tab,
            onDestinationSelected: (index) => setState(() => tab = index),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Overview'),
              NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Users'),
              NavigationDestination(
                  icon: Icon(Icons.tune),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Options'),
              NavigationDestination(
                  icon: Icon(Icons.work_outline),
                  selectedIcon: Icon(Icons.work),
                  label: 'Jobs'),
            ],
          ),
        ),
      );
}

class PortalHome extends StatefulWidget {
  final PortalData data;
  const PortalHome({super.key, required this.data});
  @override
  State<PortalHome> createState() => _PortalHomeState();
}

class _PortalHomeState extends State<PortalHome> {
  int tab = 0;
  String filter = 'All';
  final TextEditingController search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void openJob(Job job) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => JobDetailPage(job: job, data: widget.data),
        ),
      );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.data,
        builder: (context, _) {
          final recruiter = widget.data.isRecruiter;
          final pages = recruiter
              ? <Widget>[
                  recruiterJobs(),
                  postJobTab(),
                  recruiterApplications(),
                  profile(),
                ]
              : <Widget>[
                  discover(),
                  savedJobs(),
                  myApplications(),
                  profile(),
                ];
          return Scaffold(
            appBar: AppBar(
              title: const Row(children: [
                Icon(Icons.hub_rounded, color: brand),
                SizedBox(width: 9),
                Text('JobBridge',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ]),
              actions: [
                IconButton(
                  tooltip: 'Sign out',
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) widget.data.signOut();
                    });
                  },
                  icon: const Icon(Icons.logout_rounded),
                ),
                const SizedBox(width: 6),
              ],
            ),
            body: SafeArea(child: pages[tab]),
            bottomNavigationBar: NavigationBar(
              backgroundColor: Colors.white,
              selectedIndex: tab,
              onDestinationSelected: (i) => setState(() => tab = i),
              destinations: recruiter
                  ? const [
                      NavigationDestination(
                          icon: Icon(Icons.work_outline),
                          selectedIcon: Icon(Icons.work),
                          label: 'My Jobs'),
                      NavigationDestination(
                          icon: Icon(Icons.add_circle_outline),
                          selectedIcon: Icon(Icons.add_circle),
                          label: 'Post'),
                      NavigationDestination(
                          icon: Icon(Icons.people_outline),
                          selectedIcon: Icon(Icons.people),
                          label: 'Applicants'),
                      NavigationDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person),
                          label: 'Profile'),
                    ]
                  : const [
                      NavigationDestination(
                          icon: Icon(Icons.search),
                          selectedIcon: Icon(Icons.travel_explore),
                          label: 'Explore'),
                      NavigationDestination(
                          icon: Icon(Icons.bookmark_border),
                          selectedIcon: Icon(Icons.bookmark),
                          label: 'Saved'),
                      NavigationDestination(
                          icon: Icon(Icons.assignment_outlined),
                          selectedIcon: Icon(Icons.assignment),
                          label: 'Applied'),
                      NavigationDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person),
                          label: 'Profile'),
                    ],
            ),
          );
        },
      );

  Widget discover() {
    final q = search.text.trim().toLowerCase();
    final found = widget.data.jobs.where((job) {
      final searchable = '${job.title} ${job.company} ${job.location} '
              '${job.skills.join(' ')}'
          .toLowerCase();
      final matchesSearch = searchable.contains(q);
      final matchesFilter =
          filter == 'All' || job.mode == filter || job.type == filter;
      return matchesSearch && matchesFilter;
    }).toList()
      ..sort((a, b) =>
          widget.data.matchPercent(b).compareTo(widget.data.matchPercent(a)));

    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: [brand, Color(0xFF7C3AED)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Find work that fits YOU',
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(
                        'Your ${widget.data.mySkills.length} skills power your matches. '
                        'Bridge missing skills before you apply.',
                        style:
                            const TextStyle(color: Colors.white, height: 1.4)),
                  ]),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search roles, companies or skills',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: <String>{
                'All',
                ...widget.data
                    .optionsFor(PortalData.workModes)
                    .where((x) => x != 'Any'),
                ...widget.data.optionsFor(PortalData.jobTypes),
              }
                      .map((value) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(value),
                              selected: filter == value,
                              onSelected: (_) => setState(() => filter = value),
                            ),
                          ))
                      .toList()),
            ),
            const SizedBox(height: 6),
            Text('${found.length} opportunities · Sorted by skill match',
                style: const TextStyle(color: Colors.black54)),
          ]),
        ),
      ),
      if (found.isEmpty)
        SliverFillRemaining(
          hasScrollBody: false,
          child: emptyState('No matching jobs', 'Try another search or filter.',
              Icons.search_off),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => jobCard(found[i]),
              childCount: found.length,
            ),
          ),
        ),
    ]);
  }

  Widget jobCard(Job job, {bool showMatch = true}) {
    final score = widget.data.matchPercent(job);
    final isSaved = widget.data.savedIds.contains(job.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => openJob(job),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFEDE9FE),
                child: Text(job.company[0],
                    style: const TextStyle(
                        color: brand,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(job.company,
                      style: const TextStyle(color: Colors.black54)),
                ],
              )),
              if (!widget.data.isRecruiter)
                IconButton(
                  tooltip: isSaved ? 'Remove saved job' : 'Save job',
                  onPressed: () => widget.data.toggleSaved(job.id),
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? brand : Colors.black54),
                ),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 7, runSpacing: 6, children: [
              infoPill(Icons.location_on_outlined, job.location),
              infoPill(Icons.laptop_outlined, job.mode),
              infoPill(Icons.schedule, job.type),
            ]),
            const SizedBox(height: 12),
            Text(job.salary,
                style: const TextStyle(
                    color: Color(0xFF047857), fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            if (showMatch) ...[
              Row(children: [
                Expanded(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE9E9F5),
                    color: score >= 75 ? const Color(0xFF059669) : brand,
                  ),
                )),
                const SizedBox(width: 10),
                Text('$score% match',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: brand)),
              ]),
              const SizedBox(height: 7),
              Text(
                  widget.data.missingSkills(job).isEmpty
                      ? 'All listed skills matched · View role'
                      : 'SkillBridge: ${widget.data.missingSkills(job).length} skills to explore',
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ] else
              const Row(children: [
                Icon(Icons.arrow_forward, size: 17, color: brand),
                SizedBox(width: 4),
                Text('View posting', style: TextStyle(color: brand)),
              ]),
          ]),
        ),
      ),
    );
  }

  Widget savedJobs() {
    final saved = widget.data.jobs
        .where((job) => widget.data.savedIds.contains(job.id))
        .toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      sectionTitle('Saved jobs', '${saved.length} roles bookmarked'),
      Expanded(
          child: saved.isEmpty
              ? emptyState(
                  'Nothing saved yet',
                  'Bookmark jobs in Explore to see them here.',
                  Icons.bookmark_border)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: saved.length,
                  itemBuilder: (_, i) => jobCard(saved[i]),
                )),
    ]);
  }

  Widget myApplications() {
    final entries = widget.data.applications.values.toList()
      ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
    return Column(children: [
      sectionTitle(
          'My applications', '${entries.length} applications submitted'),
      Expanded(
          child: entries.isEmpty
              ? emptyState(
                  'No applications yet',
                  'Open a job and tap Apply to get started.',
                  Icons.assignment_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entries.length,
                  itemBuilder: (_, i) {
                    final a = entries[i];
                    final job =
                        widget.data.jobs.firstWhere((j) => j.id == a.jobId);
                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      child: ListTile(
                        onTap: () => openJob(job),
                        title: Text(job.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(
                            '${job.company} · ${a.matchAtApply}% skill match at application'),
                        trailing: statusTag(a.status),
                        isThreeLine: true,
                      ),
                    );
                  },
                )),
    ]);
  }

  Widget recruiterJobs() {
    final owned = widget.data.myPostedJobs;
    return Column(children: [
      sectionTitle(
          'Manage postings', '${owned.length} jobs on your demo account'),
      Expanded(
          child: owned.isEmpty
              ? emptyState(
                  'No jobs posted',
                  'Use the Post tab to create your first opening.',
                  Icons.work_outline)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: owned.length,
                  itemBuilder: (_, i) => jobCard(owned[i], showMatch: false),
                )),
    ]);
  }

  Widget postJobTab() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.post_add_rounded, size: 72, color: brand),
            const SizedBox(height: 14),
            const Text('Hire through JobBridge',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                'Create a job with required skills. Candidates will see '
                'transparent match scores and personal practice plans.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, height: 1.5)),
            const SizedBox(height: 22),
            SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create job posting'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostJobPage(
                          data: widget.data,
                          onPosted: () => setState(() => tab = 0),
                        ),
                      )),
                )),
          ]),
        ),
      );

  Widget recruiterApplications() {
    final ownedIds = widget.data.myPostedJobs.map((job) => job.id).toSet();
    final entries = widget.data.allApplications
        .where((a) => ownedIds.contains(a.jobId))
        .toList();
    return Column(children: [
      sectionTitle('Applicants', '${entries.length} candidate applications'),
      Expanded(
          child: entries.isEmpty
              ? emptyState(
                  'No applicants yet',
                  'Log in as a candidate to apply for your openings.',
                  Icons.people_outline)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entries.length,
                  itemBuilder: (_, i) {
                    final a = entries[i];
                    final job =
                        widget.data.jobs.firstWhere((j) => j.id == a.jobId);
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.name,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(a.email),
                            const SizedBox(height: 8),
                            Text('Applying for: ${job.title}'),
                            Text('Skill match when applied: ${a.matchAtApply}%',
                                style: const TextStyle(color: brand)),
                            if (widget.data
                                    .appliedCandidateProfile(a.accountEmail) !=
                                null) ...[
                              const SizedBox(height: 7),
                              Text(
                                  'Location: ${widget.data.appliedCandidateProfile(a.accountEmail)!.location}'),
                              Text(
                                  'Experience: ${widget.data.appliedCandidateProfile(a.accountEmail)!.experience}'),
                              Text(
                                  'Preferred role: ${widget.data.appliedCandidateProfile(a.accountEmail)!.preferredRole}'),
                            ],
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              key: ValueKey('${a.jobId}-${a.accountEmail}'),
                              value: a.status,
                              decoration: const InputDecoration(
                                  labelText: 'Application status'),
                              items: <String>{
                                ...widget.data.optionsFor(PortalData.statuses),
                                a.status
                              }
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (s) {
                                if (s != null)
                                  widget.data.updateApplicationStatus(a, s);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
    ]);
  }

  Widget profile() {
    final recruiter = widget.data.isRecruiter;
    final p = widget.data.myCandidateProfile;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(children: [
            CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFFEDE9FE),
                child: Icon(recruiter ? Icons.business : Icons.person,
                    size: 38, color: brand)),
            const SizedBox(height: 10),
            Text(widget.data.candidateName,
                style:
                    const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            Text(widget.data.candidateEmail,
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            Text(recruiter ? 'Recruiter account' : 'Job seeker account',
                style: const TextStyle(color: brand)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) widget.data.signOut();
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
            ),
          ]),
        ),
      ),
      if (!recruiter) ...[
        const SizedBox(height: 15),
        panel(children: [
          Row(children: [
            const Expanded(
                child: Text('My candidate profile',
                    style:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
            TextButton.icon(
              onPressed: editProfileDialog,
              icon: const Icon(Icons.edit_outlined, size: 17),
              label: const Text('Edit'),
            ),
          ]),
          const SizedBox(height: 8),
          if (p == null)
            const Text('Add your personal details to help recruiters '
                'understand your profile.')
          else ...[
            profileInfoRow(Icons.phone_outlined, 'Phone', p.phone),
            profileInfoRow(Icons.location_on_outlined, 'Location', p.location),
            profileInfoRow(Icons.school_outlined, 'Education',
                '${p.qualification} · ${p.course} (${p.graduationYear})'),
            profileInfoRow(
                Icons.work_history_outlined, 'Experience', p.experience),
            profileInfoRow(
                Icons.badge_outlined, 'Preferred role', p.preferredRole),
            profileInfoRow(Icons.laptop_outlined, 'Work mode', p.preferredMode),
            if (p.portfolio.isNotEmpty)
              profileInfoRow(Icons.link_outlined, 'Portfolio', p.portfolio),
            if (p.about.isNotEmpty)
              profileInfoRow(Icons.description_outlined, 'About', p.about),
          ],
        ]),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Your skills',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          TextButton.icon(
              onPressed: addSkillDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add skill')),
        ]),
        const Text('Match scores update whenever you edit your skills.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: (widget.data.mySkills.toList()..sort())
              .map((skill) => InputChip(
                    label: Text(skill),
                    onDeleted: () => widget.data.removeSkill(skill),
                  ))
              .toList(),
        ),
      ] else ...[
        const SizedBox(height: 16),
        ListTile(
          tileColor: Colors.white,
          leading: const Icon(Icons.work_outline, color: brand),
          title: const Text('Jobs you posted'),
          trailing: Text('${widget.data.myPostedJobs.length}'),
        ),
        const SizedBox(height: 8),
        const Text(
            'Recruiter tools are a local demo. Any sample '
            'applications are visible only for your owned postings.',
            style: TextStyle(color: Colors.black54)),
      ],
      const SizedBox(height: 28),
      const Text('DEMO LIMITATIONS',
          style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text(
          'Login/signup are in-memory demo features. No database, notifications or live employer connections. '
          'Accounts and job data reset when the app restarts; no secure password storage is provided. '
          'Match scores are rule-based, not AI hiring decisions.',
          style: TextStyle(color: Colors.black54, height: 1.5)),
    ]);
  }

  Widget profileInfoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 19, color: brand),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 3),
                Text(value),
              ])),
        ]),
      );

  Future<void> addSkillDialog() async {
    String skill = '';
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add a skill'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => skill = value,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'e.g. REST APIs'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, skill),
              child: const Text('Add')),
        ],
      ),
    );
    if (!mounted || result == null) return;
    widget.data.addSkill(result);
  }

  Future<void> editProfileDialog() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditCandidateProfilePage(data: widget.data),
    ));
  }
}

class JobDetailPage extends StatelessWidget {
  final Job job;
  final PortalData data;
  const JobDetailPage({super.key, required this.job, required this.data});

  Future<void> applyDialog(BuildContext context) async {
    if (data.applications.containsKey(job.id)) return;
    final formKey = GlobalKey<FormState>();
    String applicantName = data.candidateName;
    final submitted = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text('Apply to ${job.company}'),
            content: SingleChildScrollView(
                child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text(
                    'Submit a demo application with your profile details.'),
                const SizedBox(height: 14),
                TextFormField(
                  initialValue: applicantName,
                  onChanged: (value) => applicantName = value,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: requiredText,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: data.candidateEmail,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Account email'),
                ),
              ]),
            )),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    FocusScope.of(dialogContext).unfocus();
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Submit application')),
            ],
          ),
        ) ??
        false;
    if (submitted && context.mounted) {
      data.apply(job, applicantName, data.candidateEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demo application submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: data,
        builder: (context, _) {
          final missing = data.missingSkills(job);
          final matching = job.skills.where(data.hasSkill).toList();
          final score = data.matchPercent(job);
          final completed =
              missing.where((s) => data.practiceDone(job.id, s)).length;
          final applied = data.applications.containsKey(job.id);
          final saved = data.savedIds.contains(job.id);
          return Scaffold(
            appBar: AppBar(title: const Text('Job details')),
            bottomNavigationBar: data.isRecruiter
                ? null
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Row(children: [
                        OutlinedButton.icon(
                          onPressed: () => data.toggleSaved(job.id),
                          icon: Icon(
                              saved ? Icons.bookmark : Icons.bookmark_border),
                          label: Text(saved ? 'Saved' : 'Save'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: FilledButton.icon(
                          onPressed:
                              applied ? null : () => applyDialog(context),
                          icon: Icon(applied ? Icons.check_circle : Icons.send),
                          label: Text(applied ? 'Applied' : 'Apply now'),
                        )),
                      ]),
                    ),
                  ),
            body: ListView(padding: const EdgeInsets.all(16), children: [
              panel(children: [
                Text(job.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(job.company,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  infoPill(Icons.location_on_outlined, job.location),
                  infoPill(Icons.laptop, job.mode),
                  infoPill(Icons.schedule, job.type),
                ]),
                const SizedBox(height: 12),
                Text(job.salary,
                    style: const TextStyle(
                        color: Color(0xFF047857),
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('About the role',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(job.description, style: const TextStyle(height: 1.5)),
                const SizedBox(height: 12),
                const Text('Required skills',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        job.skills.map((s) => Chip(label: Text(s))).toList()),
              ]),
              if (!data.isRecruiter) ...[
                const SizedBox(height: 14),
                panel(children: [
                  const Row(children: [
                    Icon(Icons.auto_awesome, color: brand),
                    SizedBox(width: 8),
                    Text('SkillBridge · Your growth plan',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 6),
                  const Text(
                      'A transparent skills comparison, not an AI prediction '
                      'or a guarantee of being hired.',
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 16),
                  Row(children: [
                    Text('$score%',
                        style: const TextStyle(
                            fontSize: 30,
                            color: brand,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    const Expanded(
                        child: Text(
                            'of required skills listed '
                            'in your profile',
                            style: TextStyle(color: Colors.black54))),
                  ]),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                      value: score / 100,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(12)),
                  const SizedBox(height: 18),
                  Text('You already have (${matching.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 7),
                  matching.isEmpty
                      ? const Text('No listed skills matched yet.')
                      : Wrap(
                          spacing: 7,
                          runSpacing: 5,
                          children: matching
                              .map((s) => Chip(
                                    avatar: const Icon(Icons.check_circle,
                                        size: 17, color: Color(0xFF059669)),
                                    label: Text(s),
                                    backgroundColor: const Color(0xFFECFDF5),
                                  ))
                              .toList()),
                  const SizedBox(height: 14),
                  Text('Skills to explore (${missing.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  if (missing.isEmpty)
                    const Text('Great skill coverage! Review the job details '
                        'and apply if it matches your interests.'),
                  if (missing.isNotEmpty) ...[
                    Text(
                        '$completed of ${missing.length} practice tasks completed',
                        style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: completed / missing.length,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF059669),
                    ),
                    const SizedBox(height: 8),
                    ...missing.map((skill) => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: data.practiceDone(job.id, skill),
                          onChanged: (_) => data.togglePractice(job.id, skill),
                          title: Text('Practice $skill',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(practiceTip(skill)),
                        )),
                    const Text(
                        'Practice checkmarks track your learning tasks only. '
                        'They do not automatically claim you have mastered a skill.',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Edit skills through the Candidate Profile tab.
                    },
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Back to update skills in Profile'),
                  ),
                ]),
              ],
              const SizedBox(height: 20),
            ]),
          );
        },
      );
}

class PostJobPage extends StatefulWidget {
  final PortalData data;
  final VoidCallback onPosted;
  const PostJobPage({super.key, required this.data, required this.onPosted});
  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final keyForm = GlobalKey<FormState>();
  final title = TextEditingController();
  final company = TextEditingController();
  final location = TextEditingController();
  final salary = TextEditingController();
  final skills = TextEditingController();
  final description = TextEditingController();
  String mode = 'Hybrid';
  String type = 'Full-time';

  @override
  void initState() {
    super.initState();
    final modes = widget.data
        .optionsFor(PortalData.workModes)
        .where((v) => v != 'Any')
        .toList();
    if (!modes.contains(mode) && modes.isNotEmpty) mode = modes.first;
    final types = widget.data.optionsFor(PortalData.jobTypes);
    if (!types.contains(type) && types.isNotEmpty) type = types.first;
  }

  @override
  void dispose() {
    for (final c in [title, company, location, salary, skills, description]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!keyForm.currentState!.validate()) return;
    final skillList = skills.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
    if (skillList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one required skill.')),
      );
      return;
    }
    final data = widget.data;
    final onPosted = widget.onPosted;
    final jobTitle = title.text;
    final companyName = company.text;
    final city = location.text;
    final selectedMode = mode;
    final selectedType = type;
    final pay = salary.text;
    final details = description.text;
    final messenger = ScaffoldMessenger.of(context);
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data.postJob(
        title: jobTitle,
        company: companyName,
        location: city,
        mode: selectedMode,
        type: selectedType,
        salary: pay,
        description: details,
        skills: skillList,
      );
      onPosted();
      messenger.showSnackBar(
        const SnackBar(content: Text('Job published in the demo portal!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('New job posting')),
        body: Form(
          key: keyForm,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            field(title, 'Job title', 'e.g. Flutter Engineer'),
            field(company, 'Company name', 'e.g. NovaTech'),
            field(location, 'Location', 'e.g. Hyderabad'),
            field(salary, 'Salary / stipend', 'e.g. ₹6–10 LPA'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: mode,
              decoration: const InputDecoration(labelText: 'Work mode'),
              items: <String>{
                ...widget.data
                    .optionsFor(PortalData.workModes)
                    .where((v) => v != 'Any'),
                mode,
              }.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => mode = v ?? mode),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: type,
              decoration: const InputDecoration(labelText: 'Employment type'),
              items: <String>{
                ...widget.data.optionsFor(PortalData.jobTypes),
                type
              }.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => type = v ?? type),
            ),
            const SizedBox(height: 14),
            field(skills, 'Required skills (comma-separated)',
                'Flutter, Dart, Git'),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: TextFormField(
                controller: description,
                maxLines: 4,
                validator: requiredText,
                decoration: const InputDecoration(
                  labelText: 'Job description',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            FilledButton.icon(
                onPressed: submit,
                icon: const Icon(Icons.publish),
                label: const Text('Publish job')),
            const SizedBox(height: 16),
          ]),
        ),
      );

  Widget field(TextEditingController c, String label, String hint) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: c,
          validator: requiredText,
          decoration: InputDecoration(labelText: label, hintText: hint),
        ),
      );
}

String? requiredText(String? text) =>
    text == null || text.trim().isEmpty ? 'This field is required' : null;

String? emailValidator(String? text) {
  final email = text?.trim() ?? '';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    return 'Enter a valid email';
  }
  return null;
}

String practiceTip(String skill) {
  const tips = <String, String>{
    'REST APIs':
        'Build a mini Flutter app that fetches and displays a public API.',
    'Flutter': 'Recreate a two-screen app with forms and navigation.',
    'Dart': 'Solve five null-safety and collections exercises.',
    'Git': 'Create a repository, commit changes, and open a pull request.',
    'Firebase': 'Prototype sign-in and a simple Cloud Firestore collection.',
    'SQL': 'Write joins, grouping, and filters on a sample dataset.',
    'Python': 'Analyze a CSV file using basic Python scripts.',
    'Excel': 'Create a pivot table and a simple data dashboard.',
    'Power BI': 'Build a small dashboard from sample sales data.',
    'Figma': 'Create three mobile wireframes and a reusable component.',
    'UI Design':
        'Improve an existing mobile screen for clarity and accessibility.',
    'Prototyping': 'Link five screens into a clickable user flow.',
    'Java': 'Build a small command-line application with collections.',
    'Spring Boot': 'Create one CRUD REST endpoint with validation.',
    'Machine Learning': 'Train and evaluate a basic classification model.',
    'Pandas': 'Clean missing values and summarize a CSV dataset.',
    'Selenium': 'Automate a login-form test on a practice website.',
    'Product Analytics':
        'Define a conversion funnel and calculate drop-off rates.',
  };
  return tips[skill] ?? 'Complete a small practical project using $skill.';
}

Widget infoPill(IconData icon, String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFFF2F3F8),
          borderRadius: BorderRadius.circular(9)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Colors.black54),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ]),
    );

Widget panel({required List<Widget> children}) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );

Widget sectionTitle(String title, String subtitle) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
        ]),
      ),
    );

Widget emptyState(String title, String subtitle, IconData icon) => Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 62, color: const Color(0xFF9CA3AF)),
          const SizedBox(height: 14),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54)),
        ]),
      ),
    );

Widget statusTag(String status) {
  final color = switch (status) {
    'Shortlisted' => const Color(0xFF047857),
    'Rejected' => const Color(0xFFB91C1C),
    'Under review' => const Color(0xFFB45309),
    _ => brand,
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(10)),
    child: Text(status,
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
  );
}
