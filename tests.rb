# Basic test requires
require 'minitest/autorun'
require 'minitest/pride'

# Include both the migration and the app itself
require './migration'
require './application'

# Overwrite the development database connection with a test connection.
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3'
)

# Gotta run migrations before we can run tests.  Down will fail the first time,
# so we wrap it in a begin/rescue.
begin ApplicationMigration.migrate(:down); rescue; end
ApplicationMigration.migrate(:up)


# Finally!  Let's test the thing.
class ApplicationTest < Minitest::Test

  def test_truth
    assert true
  end

#Associate lessons with readings (both directions).
  def test_lessons_associated_with_readings
    l = Lesson.create(name: "First Lesson")
    r = Reading.create(caption: "First Reading")
    l.add_reading(r)
    assert_equal [r], Lesson.find(l.id).readings
  end

#When a lesson is destroyed, its readings should be automatically destroyed.
  def test_reading_destroyed_when_lesson_destroyed
    l = Lesson.create(name: "First Lesson")
    r = Reading.create(caption: "First Reading")
    l.add_reading(r)
    assert_equal 1, l.readings.count
    Lesson.destroy_all
    assert_equal 0, l.readings.count
  end

  #Associate courses with lessons (both directions).
    def test_courses_associated_with_lessons
      l = Lesson.create(name: "First Lesson")
      c = Course.create(name: "Computer Science")
      c.add_lesson(l)
      assert_equal [l], Course.find(c.id).lessons
    end

  #When a lesson is destroyed, its readings should be automatically destroyed.
    # def test_reading_destroyed_when_lesson_destroyed
    #   l = Lesson.create(name: "First Lesson")
    #   r = Reading.create(caption: "First Reading")
    #   l.add_reading(r)
    #   assert_equal 1, l.readings.count
    #   Lesson.destroy_all
    #   assert_equal 0, l.readings.count
    # end

end
