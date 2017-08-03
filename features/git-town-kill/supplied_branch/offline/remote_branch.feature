Feature: git town-kill: killing a remote branch in offline mode

  When offline and trying to kill a remove branch
  I want to be notified that this operation is not possible
  So that I know about my mistake and can do more appropriate actions instead.


  Background:
    Given I have a feature branch named "feature" on another machine
    And the following commit exists in my repository on another machine
      | BRANCH  | LOCATION         | MESSAGE        |
      | feature | local and remote | feature commit |
    And I am on the "main" branch
    And Git Town is in offline mode
    When I run `git-town kill feature`


  Scenario: result
    Then it runs the commands
      | BRANCH | COMMAND |
    And I get the error "There is no branch named 'feature'"
    And I am still on the "main" branch
