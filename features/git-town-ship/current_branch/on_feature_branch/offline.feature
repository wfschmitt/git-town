Feature: git town-ship: offline mode

  When offline
  I want to be able to ship branches on my local machine
  So that I can keep working as much as possible despite having no internet connection.


  Background:
    Given Git Town is in offline mode
    And I have a feature branch named "parent-feature"
    And the following commits exist in my repository
      | BRANCH         | LOCATION         | MESSAGE               | FILE NAME           | FILE CONTENT           |
      | parent-feature | local and remote | parent feature commit | parent_feature_file | parent feature content |
    And I am on the "parent-feature" branch
    When I run `git-town ship -m "parent feature done"`


  Scenario: result
    Then it runs the commands
      | BRANCH         | COMMAND                                   |
      | parent-feature | git checkout main                         |
      | main           | git rebase origin/main                    |
      |                | git checkout parent-feature               |
      | parent-feature | git merge --no-edit origin/parent-feature |
      |                | git merge --no-edit main                  |
      |                | git checkout main                         |
      | main           | git merge --squash parent-feature         |
      |                | git commit -m "parent feature done"       |
      |                | git branch -D parent-feature              |
    And I end up on the "main" branch
    And I have the following commits
      | BRANCH         | LOCATION         | MESSAGE               | FILE NAME           | FILE CONTENT           |
      | main           | local            | parent feature done   | parent_feature_file | parent feature content |
      | parent-feature | remote           | parent feature commit | parent_feature_file | parent feature content |


  Scenario: undo
    When I run `git-town ship --undo`
    Then it runs the commands
      | BRANCH         | COMMAND                                                      |
      | main           | git branch parent-feature <%= sha 'parent feature commit' %> |
      |                | git revert <%= sha 'parent feature done' %>                  |
      |                | git checkout parent-feature                                  |
      | parent-feature | git checkout main                                            |
      | main           | git reset --hard <%= sha 'Initial commit' %>            |
      |                | git checkout parent-feature                                  |
    And I end up on the "parent-feature" branch
    And I have the following commits
      | BRANCH         | LOCATION         | MESSAGE                      | FILE NAME           |
      | parent-feature | local and remote | parent feature commit        | parent_feature_file |
    And Git Town is now aware of this branch hierarchy
      | BRANCH         | PARENT         |
      | parent-feature | main           |